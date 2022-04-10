CREATE OR ALTER PROCEDURE INSERT_PRODUCT
	@categoriaId INT,
	@nombre	VARCHAR(25),
	@precio	DECIMAL,
	@cantidad INT,

	--Error case
	@error_number INT = 51000,
	@message VARCHAR(250) = 'Existe un producto con ese nombre',
	@state TINYINT = 1
AS
BEGIN
	IF EXISTS(SELECT * FROM dbo.Productos WHERE Nombre = @nombre)
	BEGIN
		 INSERT INTO Errores (codigo, mensaje, Fecha)
		 VALUES (@error_number, @message, GETDATE());

		 THROW @error_number, @message, @state
	END
	INSERT INTO dbo.Productos
		(id_Categoria, Nombre, Precio, Cantidad)
	VALUES
		(@categoriaId, @nombre, @precio, @cantidad);

END
go

EXECUTE INSERT_PRODUCT 1, 'Jordan', 500, 25;

SELECT * FROM dbo.Productos;
--DELETE FROM dbo.Producto;