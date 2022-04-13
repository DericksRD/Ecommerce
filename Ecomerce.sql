DROP DATABASE IF EXISTS Ecommerce;
go

CREATE DATABASE Ecommerce;
go

USE Ecommerce;
go

CREATE TABLE [Comprador] (
  [Id_Comprador] INT NOT NULL IDENTITY,
  [Nombre] VARCHAR(25),
  [edad] INT,
  [Sexo] BINARY,
  [Cedula] VARCHAR(13),
  [direccion] VARCHAR(50),
  [Bonos] INT,
  [Descuento] DECIMAL,
  PRIMARY KEY ([Id_Comprador])
);

CREATE TABLE [Empleado] (
  [id_Empleado] INT NOT NULL IDENTITY,
  [Nombre] VARCHAR(25),
  [edad] INT,
  [cedula] VARCHAR(25),
  [Sexo] BINARY,
  [Rol] BINARY,
  [Id_Supervirsor] INT DEFAULT 0,
  [Ventas] INT DEFAULT 0,
  PRIMARY KEY ([id_Empleado]),
  CONSTRAINT [FK_Empleado.Id_Supervirsor]
    FOREIGN KEY ([Id_Supervirsor])
      REFERENCES [Empleado]([id_Empleado])
);

CREATE NONCLUSTERED INDEX index_supervisor
ON Empleado (Id_Supervirsor);

CREATE TABLE [Tipo_Pago] (
  [id_Tipo] INT NOT NULL IDENTITY,
  [Nombre] VARCHAR(25),
  PRIMARY KEY ([id_Tipo])
);

CREATE TABLE [Factura] (
  [id_factura] INT NOT NULL IDENTITY,
  [id_Comprador] INT,
  [id_Empleado] INT,
  [fecha] DATETIME,
  [pago] DECIMAL,
  [id_Tipo] INT,
  [subtotal] DECIMAL,
  [Impuesto] DECIMAL,
  [Total] DECIMAL,
  [Bonos_Generados] INT,
  PRIMARY KEY ([id_factura]),
  CONSTRAINT [FK_Factura.id_Comprador]
    FOREIGN KEY ([id_Comprador])
      REFERENCES [Comprador]([Id_Comprador]),
  CONSTRAINT [FK_Factura.id_Empleado]
    FOREIGN KEY ([id_Empleado])
      REFERENCES [Empleado]([id_Empleado]),
  CONSTRAINT [FK_Factura.id_Tipo]
    FOREIGN KEY ([id_Tipo])
      REFERENCES [Tipo_Pago]([id_Tipo])
);

CREATE NONCLUSTERED INDEX index_comprador
ON Factura (id_Comprador);

CREATE NONCLUSTERED INDEX index_empleado
ON Factura (id_Empleado);

CREATE NONCLUSTERED INDEX index_tipo
ON Factura (id_Tipo);

CREATE TABLE [Categoria_Producto] (
  [ID_CATEGORIA] INT NOT NULL IDENTITY,
  [nombre] VARCHAR(25),
  [cantidad] INT DEFAULT 0,
  PRIMARY KEY ([ID_CATEGORIA])
);

CREATE TABLE [Productos] (
  [id_Producto] INT NOT NULL IDENTITY,
  [id_Categoria] INT,
  [Nombre] VARCHAR(25),
  [Precio] DECIMAL,
  [Cantidad] INT DEFAULT 0,
  PRIMARY KEY ([id_Producto]),
  CONSTRAINT [FK_Producto.id_Categoria]
    FOREIGN KEY ([id_Categoria])
      REFERENCES [Categoria_Producto]([ID_CATEGORIA])
);

CREATE NONCLUSTERED INDEX index_categoria
ON Productos (id_Categoria);

CREATE TABLE [Factura_Detalle] (
  [id_detalle] INT NOT NULL IDENTITY,
  [id_factura] INT,
  [id_producto] INT,
  [precio] DECIMAL,
  [cantidad] INT,
  PRIMARY KEY ([id_detalle]),
  CONSTRAINT [FK_Factura_Detalle.id_factura]
    FOREIGN KEY ([id_factura])
      REFERENCES [Factura]([id_factura]),
  CONSTRAINT [FK_Factura_Detalle.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [Productos]([id_Producto])
);

CREATE NONCLUSTERED INDEX index_factura
ON Factura_Detalle (id_factura);

CREATE NONCLUSTERED INDEX index_producto
ON Factura_Detalle (id_producto);

CREATE TABLE [Errores] (
  [id_error] INT NOT NULL IDENTITY,
  [codigo] INT NOT NULL,
  [mensaje] VARCHAR(100),
  [Fecha] DATETIME,
  PRIMARY KEY ([id_error])
);

CREATE TABLE [Acciones] (
  [id_error] INT NOT NULL IDENTITY,
  [mensaje] VARCHAR(100),
  [Fecha] DATETIME,
  PRIMARY KEY ([id_error])
);

go

/**Seed Info**/

--Categoría

INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Calzados');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Camisas');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Blusas');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Pantalones');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Faldas');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Vestidos');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Accesorios');
INSERT INTO dbo.Categoria_Producto (nombre) VALUES ('Pantalones');

go

--Tipo_Pago

INSERT INTO dbo.Tipo_Pago (nombre) VALUES ('efectivo');
INSERT INTO dbo.Tipo_Pago (nombre) VALUES ('tarjeta');
INSERT INTO dbo.Tipo_Pago (nombre) VALUES ('bono');

SELECT * FROM dbo.Categoria_Producto;
SELECT * FROM dbo.Tipo_Pago;