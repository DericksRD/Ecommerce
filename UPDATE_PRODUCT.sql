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