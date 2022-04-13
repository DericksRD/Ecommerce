CREATE OR ALTER PROCEDURE Update_Customer
	@id INT,
	@bonos INT
AS 
BEGIN
	UPDATE dbo.Comprador 
	SET
		Bonos = @bonos
	WHERE Id_Comprador = @id;

	INSERT INTO dbo.Acciones
		(mensaje, Fecha)
	VALUES
		('Ha hecho un cambio de los bonos de un Comprador. En procedure "Update_Customer"',
		 GETDATE());
END

go
