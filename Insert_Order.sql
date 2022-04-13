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

			--Insertar ventas en Vendendor
			DECLARE @ventas INT = (SELECT ventas FROM dbo.Empleado WHERE id_Empleado = @id_empleado);
			UPDATE dbo.Empleado
			SET
				Ventas = @ventas + 1
			WHERE id_Empleado = @id_empleado;
			--Actualizar Superior

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
