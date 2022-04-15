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

	DECLARE @cantidad_categoria INT = (SELECT cantidad FROM dbo.Categoria_Producto WHERE ID_CATEGORIA = @categoriaId);
	UPDATE dbo.Categoria_Producto
	SET
		cantidad = @cantidad_categoria + @cantidad
	WHERE ID_CATEGORIA = @categoriaId;

END
go

EXECUTE INSERT_PRODUCT 1, 'Jordan', 500, 25;
EXECUTE INSERT_PRODUCT 2, 'Tommy', 1100, 10;
EXECUTE INSERT_PRODUCT 1, 'Crocs', 700, 50;
EXECUTE INSERT_PRODUCT 4, 'Pantalones azules', 2000, 25;
EXECUTE INSERT_PRODUCT 4, 'Jogger Negro', 1000, 37;
EXECUTE INSERT_PRODUCT 7, 'Correa negra', 250, 25;
EXECUTE INSERT_PRODUCT 7, 'Par de Aretes pequeños', 300, 50;
EXECUTE INSERT_PRODUCT 5, 'Mini falda rosada', 850, 10;
EXECUTE INSERT_PRODUCT 5, 'Falda larga negra', 900, 40;

SELECT * FROM dbo.Productos;
--DELETE FROM dbo.Producto;