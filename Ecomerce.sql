DROP DATABASE IF EXISTS Ecommerce;
go

CREATE DATABASE Ecommerce;
go

USE Ecommerce;
go

CREATE TABLE [Comprador] (
  [Id_Comprador] INT,
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
  [id_Empleado] INT,
  [Nombre] VARCHAR(25),
  [edad] INT,
  [cedula] VARCHAR(25),
  [Sexo] BINARY,
  [Rol] BINARY,
  [Id_Supervirsor] INT,
  [Ventas] INT,
  PRIMARY KEY ([id_Empleado]),
  CONSTRAINT [FK_Empleado.Id_Supervirsor]
    FOREIGN KEY ([Id_Supervirsor])
      REFERENCES [Empleado]([id_Empleado])
);

CREATE NONCLUSTERED INDEX index_supervisor
ON Empleado (Id_Supervirsor);

CREATE TABLE [Tipo_Pago] (
  [id_Tipo] INT,
  [Nombre] VARCHAR(25),
  PRIMARY KEY ([id_Tipo])
);

CREATE TABLE [Factura] (
  [id_factura] INT,
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
  [ID_CATEGORIA] INT,
  [nombre] VARCHAR(25),
  [cantidad] INT,
  PRIMARY KEY ([ID_CATEGORIA])
);

CREATE TABLE [Producto] (
  [id_Producto] INT,
  [id_Categoria] INT,
  [Nombre] VARCHAR(25),
  [Precio] DECIMAL,
  [Cantidad] INT,
  PRIMARY KEY ([id_Producto]),
  CONSTRAINT [FK_Producto.id_Categoria]
    FOREIGN KEY ([id_Categoria])
      REFERENCES [Categoria_Producto]([ID_CATEGORIA])
);

CREATE NONCLUSTERED INDEX index_categoria
ON Producto (id_Categoria);

CREATE TABLE [Factura_Detalle] (
  [id_detalle] INT,
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
      REFERENCES [Producto]([id_Producto])
);

CREATE NONCLUSTERED INDEX index_factura
ON Factura_Detalle (id_factura);

CREATE NONCLUSTERED INDEX index_producto
ON Factura_Detalle (id_producto);

CREATE TABLE [Errores] (
  [id_error] INT,
  [mensaje] VARCHAR(100),
  [Fecha] DATETIME,
  PRIMARY KEY ([id_error])
);

CREATE TABLE [Acciones] (
  [id_error] INT,
  [mensaje] VARCHAR(100),
  [Fecha] DATETIME,
  PRIMARY KEY ([id_error])
);