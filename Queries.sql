CREATE OR ALTER PROCEDURE Top_Products
AS
	SELECT TOP 5 * FROM dbo.Productos;
go

CREATE OR ALTER PROCEDURE Top_Products_By_Customer
	@id_comprador INT
AS
BEGIN
	SELECT * INTO #Facturas
	FROM dbo.Factura
	WHERE id_Comprador = @id_comprador;


	SELECT * FROM dbo.Productos
	WHERE id_Producto = ( 
		SELECT 
			MAX(id_Producto) 
		FROM dbo.Factura_Detalle fd
		INNER JOIN #Facturas f
			ON fd.id_factura = f.id_factura
		WHERE fd.id_factura = f.id_factura
	);

	DROP TABLE #Facturas;
END
go

CREATE OR ALTER PROCEDURE Top_Customer
AS
	SELECT TOP 1 * FROM dbo.Comprador
	WHERE Bonos = (SELECT MAX(bonos) FROM dbo.Comprador);
go

CREATE OR ALTER PROCEDURE Ranking
AS

	SELECT
		p.id_Categoria,
		COUNT(*) AS Ventas
	FROM dbo.Factura_Detalle fd
	INNER JOIN dbo.Productos p
		ON fd.id_producto = p.id_Producto
	GROUP BY p.id_Categoria
	ORDER BY COUNT(*) DESC

	SELECT
		p.id_producto,
		p.id_categoria,
		COUNT(*) AS Ventas
	FROM dbo.Factura_Detalle fd
	INNER JOIN dbo.Productos p
		ON fd.id_producto = p.id_Producto
	GROUP BY p.id_Producto, p.id_Categoria
	ORDER BY p.id_Categoria DESC, COUNT(*) DESC
go

CREATE OR ALTER PROCEDURE Invoice
AS
	SELECT
		Nombre,
		p.Cantidad,
		COUNT(*) AS Ventas
	FROM dbo.Productos p
	INNER JOIN dbo.Factura_Detalle fd
		ON p.id_Producto = fd.id_producto
	GROUP BY Nombre, p.Cantidad
go