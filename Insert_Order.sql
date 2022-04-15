CREATE OR ALTER PROCEDURE Insert_Order
	@id_comprador INT,
	@id_empleado INT,
	@id_tipo INT,
	@pago DECIMAL,
	@subtotal DECIMAL,
	@id_producto INT, --Debería ser una lista.
	@cantidad_producto INT
AS
BEGIN
	--In case of error:
	DECLARE @error_number INT = 52000;
	DECLARE @message VARCHAR(250) = 'No hay suficiente cantidad de ese producto. En Procedure "Insert_Order"';
	DECLARE @state TINYINT = 1

	--Comprobar si hay algún dato vacío
	IF(@id_comprador IS NULL OR @id_empleado IS NULL OR
	   @id_tipo IS NULL OR @pago IS NULL OR @subtotal IS NULL)
	BEGIN
		SET @error_number = 53000;
		SET @message = 'No se aceptan valores vacíos. En Procedure "Insert_Order"';

		INSERT INTO Errores (codigo, mensaje, Fecha)
		VALUES (@error_number, @message, GETDATE());

		THROW @error_number, @message, @state
	END

	--Comprobar si existe el cliente
	IF NOT EXISTS (SELECT * FROM dbo.Comprador WHERE Id_Comprador = @id_comprador)
	BEGIN
		SET @error_number = 54000;
		SET @message = 'No existe ningún comprador con ese id. En Procedure "Insert_Order"';

		INSERT INTO Errores (codigo, mensaje, Fecha)
		VALUES (@error_number, @message, GETDATE());

		THROW @error_number, @message, @state
	END

	--Comprobar si existe el empleado
	IF NOT EXISTS (SELECT * FROM dbo.Empleado WHERE id_Empleado = @id_empleado)
	BEGIN
		SET @error_number = 55000;
		SET @message = 'No existe ningún empleado con ese id. En Procedure "Insert_Order"';

		INSERT INTO Errores (codigo, mensaje, Fecha)
		VALUES (@error_number, @message, GETDATE());

		THROW @error_number, @message, @state
	END

	--Comprobar si hay productos en stock
	DECLARE @cantidad INT;
	SET @cantidad = (SELECT Cantidad FROM dbo.Productos WHERE id_Producto = @id_producto);

	IF @cantidad < @cantidad_producto
	BEGIN
		INSERT INTO Errores (codigo, mensaje, Fecha)
		VALUES (@error_number, @message, GETDATE());

		THROW @error_number, @message, @state
	END

	--Calcular Bonos
	DECLARE @bonos INT;
	SET @bonos = (SELECT Bonos FROM dbo.Comprador WHERE Id_Comprador = @id_comprador);
	
	BEGIN TRAN
		IF @id_tipo = 3 --El comprador va a usar sus bonos.
		BEGIN

			IF @subtotal > @bonos
			BEGIN 
				SET @error_number = 56000;
				SET @message = 'El comrpador no tiene la suficiente cantidad de bonos. En Procedure "Insert_Order"';

				INSERT INTO Errores (codigo, mensaje, Fecha)
				VALUES (@error_number, @message, GETDATE());

				THROW @error_number, @message, @state
			END
			
			--Descontar bonos
			UPDATE dbo.Comprador 
			SET
				Bonos = @bonos - @subtotal
			WHERE Id_Comprador = @id_comprador;

			INSERT INTO dbo.Acciones
				(mensaje, Fecha)
			VALUES
				('Ha hecho un cambio de los bonos de un Comprador. En procedure "Insert_Order"',
				 GETDATE());
		END

		BEGIN TRY
			DECLARE @bonos_generados INT;
			SET @bonos_generados = @subtotal / 50;
			UPDATE dbo.Comprador 
			SET
				Bonos = @bonos + @bonos_generados
			WHERE Id_Comprador = @id_comprador;

			INSERT INTO dbo.Acciones
				(mensaje, Fecha)
			VALUES
				('Ha hecho un cambio de los bonos de un Comprador. En procedure "Insert_Order"',
				 GETDATE());

			--Insertar factura

			INSERT INTO dbo.Factura
				(id_Comprador, id_Empleado, fecha, pago, id_Tipo, subtotal, Impuesto, Total, Bonos_Generados)
			VALUES
				(@id_comprador, @id_empleado, GETDATE(), @subtotal, @id_tipo, @subtotal, 0.18, @subtotal + 0.18, @bonos + @bonos_generados);

			INSERT INTO dbo.Acciones
				(mensaje, Fecha)
			VALUES
				('Factura ingresada desde Procedure "Insert_Order"', GETDATE());

			--Insertar ventas en Empleado
			DECLARE @ventas INT = (SELECT ventas FROM dbo.Empleado WHERE id_Empleado = @id_empleado);
			UPDATE dbo.Empleado
			SET
				Ventas = @ventas + 1
			WHERE id_Empleado = @id_empleado;

			--Actualizar Superior
			DECLARE @id_supervisor INT = (SELECT Id_Supervirsor FROM dbo.Empleado WHERE id_Empleado = @id_empleado);
			SET @ventas = (SELECT ventas FROM dbo.Empleado WHERE id_Empleado = @id_supervisor);
			UPDATE dbo.Empleado
			SET
				Ventas = @ventas + 1
			WHERE id_Empleado = @id_supervisor;

			--Insertar Factura detalle
			DECLARE @id_factura INT = (SELECT id_factura From dbo.Factura
									   WHERE id_Comprador = @id_comprador AND
											 id_Empleado = @id_empleado AND
											 subtotal = @subtotal);

			DECLARE @precio DECIMAL = (SELECT precio FROM dbo.Productos WHERE id_Producto = @id_producto);
			
			INSERT INTO dbo.Factura_Detalle
				(id_factura, id_producto, precio, cantidad)
			VALUES
				(@id_factura, @id_producto, @precio, @cantidad_producto);

			INSERT INTO dbo.Acciones
				(mensaje, Fecha)
			VALUES
				('Detalle de Factura ingresado desde Procedure "Insert_Order"', GETDATE());

			--Descontar la cantidad
			UPDATE dbo.Productos
			SET
				Cantidad = @cantidad - @cantidad_producto
			WHERE id_Producto = @id_producto;

			COMMIT;
		END TRY
		BEGIN CATCH
			INSERT INTO dbo.Errores
				(mensaje, Fecha)
			VALUES
				('Ocurrió un error insertando una factura. En procedure "Insert_Order"', 
				 GETDATE());

			ROLLBACK;
		END CATCH
END
go

--Debe insertar al menos 100 ventas por cada vendedor y 10 por cada cliente.
DECLARE @i INT = 0;

WHILE @i < 500
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @id_comprador INT = (FLOOR(RAND()*(14-1+1)+1)); --Num >= 1 and num <= 14

			DECLARE @id_empleado INT;

			DECLARE @finish BIT = 0;
			WHILE @finish = 0
			BEGIN
				SET @id_empleado = (FLOOR(RAND()*(9-1+1)+1));

				IF (SELECT Id_Supervirsor FROM dbo.Empleado WHERE id_Empleado = @id_empleado) IS NOT NULL
				BEGIN
					SET @finish = 1;
				END
			END

			DECLARE @id_producto INT = (FLOOR(RAND()*(9-1+1)+1));

			DECLARE @precio DECIMAL = (SELECT Precio FROM dbo.Productos WHERE id_Producto = @id_producto);
			DECLARE @cantidad_actual INT = (SELECT Cantidad FROM dbo.Productos WHERE id_Producto = @id_producto);
			IF @cantidad_actual = 0
			BEGIN
				SET @cantidad_actual = 500;
			END
			DECLARE @cantidad INT = (FLOOR(RAND()*(5-1+1)+1));

			DECLARE @subtotal DECIMAL = @precio * @cantidad;

			DECLARE @id_tipo INT;

			SET @finish = 0;
			WHILE @finish = 0
			BEGIN
				SET @finish = 1;

				SET @id_tipo = (FLOOR(RAND()*(3-1+1)+1));
				IF @id_tipo = 3
				BEGIN
					DECLARE @bonos INT = (SELECT bonos FROM dbo.Comprador WHERE Id_Comprador = @id_comprador);
					IF @bonos < @subtotal
					BEGIN
						SET @finish = 0; --El ciclo continua.
					END
				END
			END

			EXECUTE Insert_Order @id_comprador, @id_empleado, @id_tipo, @subtotal, @subtotal, @id_producto, @cantidad;

			SET @i = @i + 1;
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Ha ocurrido un error ingresando los registros';
	END CATCH
END
go