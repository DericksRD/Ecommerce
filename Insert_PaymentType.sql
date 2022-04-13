CREATE OR ALTER PROCEDURE Insert_PaymentType
	@nombre VARCHAR(25)
AS
BEGIN
	INSERT INTO dbo.Tipo_Pago (Nombre) VALUES (@nombre);

	INSERT INTO dbo.Acciones
		(mensaje, Fecha)
	VALUES
		('Nuevo tipo de pago registrado', GETDATE())
END;
go

