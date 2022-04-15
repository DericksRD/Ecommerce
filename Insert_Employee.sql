CREATE OR ALTER PROCEDURE Insert_Employee
	@nombre VARCHAR(25),
	@edad INT,
	@cedula VARCHAR(25),
	@sexo BINARY,
	@rol BINARY, --0: Empleado, 1: Supervisor
	@id_supervisor INT = null,
	@ventas INT = 0 --la suma de las ventas de los empleados.
AS
BEGIN
	INSERT INTO dbo.Empleado
		(Nombre, edad, cedula, Sexo, Rol, Id_Supervirsor, Ventas)
	VALUES
		(@nombre, @edad, @cedula, @sexo, @rol, @id_supervisor, @ventas);
		--TODO: Calcular ventas.

	INSERT INTO dbo.Acciones
		(mensaje, Fecha)
	VALUES
		('Empleado registrado.', GETDATE())
END;
go

EXECUTE Insert_Employee 'Francia', 35, '00145761684', 1, 1;
EXECUTE Insert_Employee 'Enmanuel', 28, '00112456789', 0, 0, 1;
EXECUTE Insert_Employee 'Patricia', 23, '00152456788', 1, 1;
EXECUTE Insert_Employee 'Rolando', 20, '40212456789', 1, 0, 3;
EXECUTE Insert_Employee 'Erick', 27, '00112476281', 1, 0, 3;
EXECUTE Insert_Employee 'Raquel', 40, '00149356469', 0, 1;
EXECUTE Insert_Employee 'Derick', 20, '40200761761', 1, 0, 7;
EXECUTE Insert_Employee 'Rafael', 28, '01300006242', 1, 0, 7;
EXECUTE Insert_Employee 'Fabiola', 28, '40216842597', 0, 0, 7;



SELECT * FROM dbo.Empleado;
