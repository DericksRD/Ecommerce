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
EXECUTE Insert_Customers 'Erick', 20, 1, '40200761761', 'Alma Rosa I';
EXECUTE Insert_Customers 'Pablo', 22, 1, '40200761654', 'Ensanche Ozama';
EXECUTE Insert_Customers 'José', 19, 1, '00100761761', 'Los Corales';
EXECUTE Insert_Customers 'Jillian', 21, 0, '40207831761', 'Puerto Rico';
EXECUTE Insert_Customers 'Gladys', 20, 0, '40200761345', 'Kilómetro 9';
EXECUTE Insert_Customers 'Jaime', 20, 1, '40200764689', 'Gazcue';
EXECUTE Insert_Customers 'Rachel', 19, 0, '40200103251', 'El millón';
EXECUTE Insert_Customers 'Derick', 20, 1, '40200761761', 'Jesús de Galindez';
EXECUTE Insert_Customers 'Angel', 20, 1, '40207618761', 'Costa Rica';
EXECUTE Insert_Customers 'Ivana', 20, 0, '40234811761', 'Los Proceres';
EXECUTE Insert_Customers 'Marcos', 27, 1, '40200764633', 'Parque Italia';
EXECUTE Insert_Customers 'Lissette', 19, 0, '00100761345', 'New York';
EXECUTE Insert_Customers 'Luisanna', 19, 0, '40200743681', 'Club de Leones';

SELECT * FROM dbo.Comprador;
