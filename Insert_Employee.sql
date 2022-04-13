CREATE OR ALTER PROCEDURE Insert_Employee
	@nombre VARCHAR(25),
	@edad INT,
	@cedula VARCHAR(25),
	@sexo BINARY,
	@rol BINARY,
	@id_supervisor INT,
	@ventas INT --la suma de las ventas de los empleados.
AS
	INSERT INTO dbo.Empleado
		(Nombre, edad, cedula, Sexo, Rol, Id_Supervirsor, Ventas)
	VALUES
		(@nombre, @edad, @cedula, @sexo, @rol, @id_supervisor, @ventas);
go

EXECUTE Insert_Employee 'Francia', 35, '00145761684', 1, 0, 1, 10;
SELECT * FROM dbo.Empleado;
