CREATE OR ALTER PROCEDURE Insert_Customers
	@nombre VARCHAR(25),
	@edad INT,
	@Sexo BINARY,
	@Cedula VARCHAR(13),
	@direccion VARCHAR(50),
	@bonos INT = 0,
	@numero_clientes INT = 0
AS
BEGIN
	SET @numero_clientes = (SELECT COUNT(Nombre) FROM Dbo.Comprador);

	SET @bonos = CASE 
		WHEN @numero_clientes < 5 THEN 500
		WHEN @numero_clientes BETWEEN 5 AND 15 THEN 400
		WHEN @numero_clientes BETWEEN 15 AND 20 THEN 200
		ELSE 0
	END;

	INSERT INTO dbo.Comprador
		(Nombre, edad, Sexo, Cedula, Direccion, Bonos)
	VALUES 
		(@nombre, @edad, @Sexo, @Cedula, @direccion, @bonos);

	INSERT INTO dbo.Acciones
		(mensaje, Fecha)
	VALUES
		('Ha Insertado un nuevo comprador',
		 GETDATE())
END
go

EXECUTE Insert_Customers 'Rafael', 20, 1, '40200761761', 'Club de Leones';
SELECT * FROM dbo.Comprador;
SELECT * FROM dbo.Acciones;
