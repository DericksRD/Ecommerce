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