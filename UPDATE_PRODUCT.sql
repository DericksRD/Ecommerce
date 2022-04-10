CREATE OR ALTER PROCEDURE UPDATE_PRODUCT
	@id INT,
	@nombre VARCHAR(25),
	@precio DECIMAL,
	@cantidad INT
AS
	UPDATE dbo.Productos 
	SET
		Nombre = @nombre,
		Precio = @precio,
		cantidad = @cantidad
	WHERE id_Producto = @id
	
GO

DECLARE @cantidad INT
SET @cantidad = (SELECT Cantidad FROM dbo.Productos WHERE id_Producto = 1) - 1
EXECUTE UPDATE_PRODUCT 1, 'Tenis', 500, @cantidad

SELECT * FROM dbo.Productos;