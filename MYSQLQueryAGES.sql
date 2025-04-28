-- CREAR BASE DE DATOS
CREATE DATABASE AGES;
USE AGES;

-- CREACIÓN DE TABLAS
-- Tabla Productos: Contiene la información de los productos almacenados.
CREATE TABLE Productos (
    IdProducto INT AUTO_INCREMENT PRIMARY KEY,
	Referencia VARCHAR(50) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
    Cantidad INT NOT NULL ,
	Alerta INT NOT NULL,
    ValorUnitario INT NOT NULL,
    eliminado bool,
    CONSTRAINT chk_cantidad CHECK (Cantidad >= 0)
);


-- Tabla CompraProducto: Registra información sobre las compras realizadas.
CREATE TABLE Compra (
    IdCompra INT AUTO_INCREMENT PRIMARY KEY,
    Cantidad INT NOT NULL,
    ValorUnitario INT NOT NULL,
	Fecha DATETIME NOT NULL
);

-- Tabla VentaProducto: Registra información sobre las ventas realizadas.
CREATE TABLE Venta (
    IdVenta INT AUTO_INCREMENT PRIMARY KEY,
    Cantidad INT NOT NULL,
	Fecha DATETIME NOT NULL	
);

-- Tabla Usuario: Contiene los usuarios para gestionar el inicio de sesión.
CREATE TABLE Usuario (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(50) NOT NULL,
    Contraseña VARCHAR(200) NOT NULL,
    Cargo VARCHAR(50) NOT NULL
);

-- Tabla Ingreso: Registra los ingresos de productos asociados a compras.
CREATE TABLE Ingreso (
    IdIngreso INT,
    IdProducto INT NOT NULL,
    IdCompra INT NOT NULL,
    CONSTRAINT FK_Ingreso_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE,
    CONSTRAINT FK_Ingreso_Compra FOREIGN KEY (IdCompra) REFERENCES Compra(IdCompra) ON DELETE CASCADE
);

-- Tabla Salida: Registra las salidas de productos relacionados con compras.
CREATE TABLE Salida (
    IdSalida INT,
    IdProducto INT NOT NULL,
    IdVenta INT NOT NULL,
    CONSTRAINT FK_Salida_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE,
    CONSTRAINT FK_Salida_Venta FOREIGN KEY (IdVenta) REFERENCES Venta(IdVenta) ON DELETE CASCADE
);



-- ALTER TABLE VentaProducto
-- ADD CONSTRAINT chk_PrecioVentaMayorBase 
-- CHECK (ValorUnitarioV >= (SELECT PrecioBase FROM Productos WHERE IdProducto = IdProducto));


-- CREACIÓN DE ÍNDICES
-- Índices en la tabla Productos
CREATE INDEX IDX_Productos_Nombre ON Productos(Nombre);
CREATE INDEX IDX_Productos_Referencia ON Productos(Referencia);
CREATE INDEX IDX_Productos_CantidadActual ON Productos(Cantidad);
CREATE INDEX IDX_Productos_CantidadActual ON Productos(Cantidad);

-- Índices en la tabla Ingreso
CREATE INDEX IDX_Ingreso_ProductoCompra ON Ingreso(IdProducto, IdCompra);

-- Índices en la tabla Salida
CREATE INDEX IDX_Salida_ProductoVenta ON Salida(IdProducto, IdVenta);

-- Índices en la tabla CompraProducto
CREATE INDEX IDX_CompraProducto_FechaCantidad ON Compra(Fecha, Cantidad);
CREATE INDEX IDX_CompraProducto_FechaCantidad ON Compra(Fecha, Cantidad);

-- Índices en la tabla VentaProducto
CREATE INDEX IDX_VentaProducto_FechaCantidad ON Venta(Fecha, Cantidad);
CREATE INDEX IDX_VentaProducto_FechaCantidad ON Venta(Fecha, Cantidad);

-- Índices en la tabla Usuario
CREATE UNIQUE INDEX IDX_Usuario_Usuario ON Usuario(Usuario);

-- Insertar 20 productos de seguridad industrial
INSERT INTO Productos (Referencia, Nombre, Cantidad, Alerta, ValorUnitario) VALUES
-- Equipos de protección personal
('GUANTE-001', 'Guantes de nitrilo', 50, 10, 13000), -- Precio compra: 10,000
('GUANTE-002', 'Guantes anticorte', 50, 10, 19500), -- Precio compra: 15,000
('CASCO-001', 'Casco seguridad', 50, 10, 26000), -- Precio compra: 20,000
('GAFAS-001', 'Gafas protección', 50, 10, 16250), -- Precio compra: 12,500
('AUDIT-001', 'Audífonos protectores', 50, 10, 22750), -- Precio compra: 17,500
('RESPI-001', 'Respirador N95', 50, 10, 6500), -- Precio compra: 5,000
('BOTA-001', 'Botas seguridad', 50, 10, 32500), -- Precio compra: 25,000
-- Ropa de protección
('OVEROL-001', 'Overol antiácido', 50, 10, 45500), -- Precio compra: 35,000
('CHALECO-001', 'Chaleco reflectivo', 50, 10, 19500), -- Precio compra: 15,000
('ARNES-001', 'Arnés seguridad', 50, 10, 58500), -- Precio compra: 45,000
-- Señalización
('CONO-001', 'Cono reflectivo', 50, 10, 9750), -- Precio compra: 7,500
('LETRERO-001', 'Letrero peligro', 50, 10, 6500), -- Precio compra: 5,000
('BANDERA-001', 'Bandera señalización', 50, 10, 8450), -- Precio compra: 6,500
-- Extintores
('EXT-001', 'Extintor CO2 5kg', 50, 10, 104000), -- Precio compra: 80,000
('EXT-002', 'Extintor polvo 10kg', 50, 10, 136500), -- Precio compra: 105,000
-- Primeros auxilios
('BOTI-001', 'Botiquín básico', 50, 10, 65000), -- Precio compra: 50,000
('KIT-001', 'Kit quemaduras', 50, 10, 91000), -- Precio compra: 70,000
-- Otros
('CINTA-001', 'Cinta peligro', 50, 10, 3250), -- Precio compra: 2,500
('LINTA-001', 'Lintera seguridad', 50, 10, 8450), -- Precio compra: 6,500
('TAPON-001', 'Tapones oídos', 50, 10, 1950); -- Precio compra: 1,500

-- Insertar 10 compras
-- Compra 1
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (20, 10000, '2025-01-05');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (1, 1, 1);

-- Compra 2
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (15, 15000, '2025-01-10');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (10, 20000, '2025-01-10');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (2, 2, 2);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (2, 3, 3);

-- Compra 3
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (25, 12500, '2025-01-15');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (15, 17500, '2025-01-15');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (3, 4, 4);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (3, 5, 5);

-- Compra 4
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (30, 5000, '2025-02-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (10, 25000, '2025-02-01');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (4, 6, 6);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (4, 7, 7);

-- Compra 5
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (5, 35000, '2025-02-10');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (20, 15000, '2025-02-10');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (5, 8, 8);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (5, 9, 9);

-- Compra 6
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (8, 45000, '2025-02-15');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (50, 7500, '2025-02-15');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (6, 10, 10);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (6, 11, 11);

-- Compra 7
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (30, 5000, '2025-03-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (20, 6500, '2025-03-01');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (7, 12, 12);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (7, 13, 13);

-- Compra 8
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (10, 80000, '2025-03-10');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (5, 105000, '2025-03-10');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (8, 14, 14);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (8, 15, 15);

-- Compra 9
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (8, 50000, '2025-03-15');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (5, 70000, '2025-03-15');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (9, 16, 16);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (9, 17, 17);

-- Compra 10
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (100, 2500, '2025-04-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (50, 6500, '2025-04-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (200, 1500, '2025-04-01');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (10, 18, 18);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (10, 19, 19);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (10, 20, 20);

-- Insertar 10 ventas
-- Venta 1 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-01-20');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-01-20');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-01-20');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (1, 1, 1);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (1, 3, 2);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (1, 5, 3);

-- Venta 2 (4 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-01-25');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-01-25');
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-01-25');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-01-25');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 2, 4);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 4, 5);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 6, 6);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 8, 7);

-- Venta 3 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (15, '2025-02-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-02-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (1, '2025-02-05');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (3, 7, 8);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (3, 9, 9);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (3, 11, 10);

-- Venta 4 (5 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (20, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-02-10');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 10, 11);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 12, 12);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 14, 13);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 16, 14);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 18, 15);

-- Venta 5 (4 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-02-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (4, '2025-02-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (6, '2025-02-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-02-15');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 13, 16);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 15, 17);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 17, 18);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 19, 19);

-- Venta 6 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (12, '2025-03-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-03-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-03-01');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (6, 1, 20);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (6, 5, 21);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (6, 20, 22);

-- Venta 7 (5 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (7, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (9, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (4, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (1, '2025-03-10');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 3, 23);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 7, 24);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 11, 25);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 15, 26);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 19, 27);

-- Venta 8 (4 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (15, '2025-03-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-03-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (6, '2025-03-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-03-15');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 2, 28);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 6, 29);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 10, 30);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 14, 31);

-- Venta 9 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-04-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-04-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-04-01');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 4, 32);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 8, 33);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 12, 34);

-- Venta 10 (5 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (20, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (15, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-04-05');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 9, 35);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 13, 36);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 17, 37);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 18, 38);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 20, 39);
-- Insertar 20 productos de seguridad industrial
INSERT INTO Productos (Referencia, Nombre, Cantidad, Alerta, ValorUnitario) VALUES
-- Equipos de protección personal
('GUANTE-001', 'Guantes de nitrilo', 50, 10, 13000), -- Precio compra: 10,000
('GUANTE-002', 'Guantes anticorte', 50, 10, 19500), -- Precio compra: 15,000
('CASCO-001', 'Casco seguridad', 50, 10, 26000), -- Precio compra: 20,000
('GAFAS-001', 'Gafas protección', 50, 10, 16250), -- Precio compra: 12,500
('AUDIT-001', 'Audífonos protectores', 50, 10, 22750), -- Precio compra: 17,500
('RESPI-001', 'Respirador N95', 50, 10, 6500), -- Precio compra: 5,000
('BOTA-001', 'Botas seguridad', 50, 10, 32500), -- Precio compra: 25,000
-- Ropa de protección
('OVEROL-001', 'Overol antiácido', 50, 10, 45500), -- Precio compra: 35,000
('CHALECO-001', 'Chaleco reflectivo', 50, 10, 19500), -- Precio compra: 15,000
('ARNES-001', 'Arnés seguridad', 50, 10, 58500), -- Precio compra: 45,000
-- Señalización
('CONO-001', 'Cono reflectivo', 50, 10, 9750), -- Precio compra: 7,500
('LETRERO-001', 'Letrero peligro', 50, 10, 6500), -- Precio compra: 5,000
('BANDERA-001', 'Bandera señalización', 50, 10, 8450), -- Precio compra: 6,500
-- Extintores
('EXT-001', 'Extintor CO2 5kg', 50, 10, 104000), -- Precio compra: 80,000
('EXT-002', 'Extintor polvo 10kg', 50, 10, 136500), -- Precio compra: 105,000
-- Primeros auxilios
('BOTI-001', 'Botiquín básico', 50, 10, 65000), -- Precio compra: 50,000
('KIT-001', 'Kit quemaduras', 50, 10, 91000), -- Precio compra: 70,000
-- Otros
('CINTA-001', 'Cinta peligro', 50, 10, 3250), -- Precio compra: 2,500
('LINTA-001', 'Lintera seguridad', 50, 10, 8450), -- Precio compra: 6,500
('TAPON-001', 'Tapones oídos', 50, 10, 1950); -- Precio compra: 1,500

-- Insertar 10 compras
-- Compra 1
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (20, 10000, '2025-01-05');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (1, 1, 1);

-- Compra 2
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (15, 15000, '2025-01-10');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (10, 20000, '2025-01-10');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (2, 2, 2);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (2, 3, 3);

-- Compra 3
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (25, 12500, '2025-01-15');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (15, 17500, '2025-01-15');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (3, 4, 4);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (3, 5, 5);

-- Compra 4
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (30, 5000, '2025-02-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (10, 25000, '2025-02-01');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (4, 6, 6);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (4, 7, 7);

-- Compra 5
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (5, 35000, '2025-02-10');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (20, 15000, '2025-02-10');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (5, 8, 8);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (5, 9, 9);

-- Compra 6
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (8, 45000, '2025-02-15');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (50, 7500, '2025-02-15');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (6, 10, 10);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (6, 11, 11);

-- Compra 7
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (30, 5000, '2025-03-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (20, 6500, '2025-03-01');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (7, 12, 12);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (7, 13, 13);

-- Compra 8
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (10, 80000, '2025-03-10');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (5, 105000, '2025-03-10');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (8, 14, 14);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (8, 15, 15);

-- Compra 9
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (8, 50000, '2025-03-15');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (5, 70000, '2025-03-15');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (9, 16, 16);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (9, 17, 17);

-- Compra 10
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (100, 2500, '2025-04-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (50, 6500, '2025-04-01');
INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (200, 1500, '2025-04-01');
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (10, 18, 18);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (10, 19, 19);
INSERT INTO Ingreso (IdProducto, IdCompra) VALUES (10, 20, 20);

-- Insertar 10 ventas
-- Venta 1 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-01-20');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-01-20');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-01-20');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (1, 1, 1);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (1, 3, 2);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (1, 5, 3);

-- Venta 2 (4 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-01-25');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-01-25');
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-01-25');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-01-25');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 2, 4);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 4, 5);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 6, 6);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (2, 8, 7);

-- Venta 3 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (15, '2025-02-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-02-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (1, '2025-02-05');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (3, 7, 8);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (3, 9, 9);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (3, 11, 10);

-- Venta 4 (5 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (20, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-02-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-02-10');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 10, 11);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 12, 12);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 14, 13);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 16, 14);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (4, 18, 15);

-- Venta 5 (4 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-02-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (4, '2025-02-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (6, '2025-02-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-02-15');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 13, 16);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 15, 17);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 17, 18);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (5, 19, 19);

-- Venta 6 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (12, '2025-03-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-03-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-03-01');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (6, 1, 20);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (6, 5, 21);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (6, 20, 22);

-- Venta 7 (5 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (7, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (9, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (4, '2025-03-10');
INSERT INTO Venta (Cantidad, Fecha) VALUES (1, '2025-03-10');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 3, 23);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 7, 24);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 11, 25);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 15, 26);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (7, 19, 27);

-- Venta 8 (4 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (15, '2025-03-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-03-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (6, '2025-03-15');
INSERT INTO Venta (Cantidad, Fecha) VALUES (3, '2025-03-15');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 2, 28);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 6, 29);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 10, 30);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 14, 31);

-- Venta 9 (3 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-04-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-04-01');
INSERT INTO Venta (Cantidad, Fecha) VALUES (2, '2025-04-01');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 4, 32);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 8, 33);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (8, 12, 34);

-- Venta 10 (5 productos)
INSERT INTO Venta (Cantidad, Fecha) VALUES (20, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (10, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (15, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (5, '2025-04-05');
INSERT INTO Venta (Cantidad, Fecha) VALUES (8, '2025-04-05');
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 9, 35);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 13, 36);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 17, 37);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 18, 38);
INSERT INTO Salida (IdProducto, IdVenta) VALUES (9, 20, 39);

-- TRIGGERS
-- Trigger para incrementar la cantidad al realizar una compra y disminuir en venta
-- Trigger para incrementar la cantidad al realizar una compra y disminuir en venta
DELIMITER //

CREATE TRIGGER trg_ValidarReferenciaAntesInsert
BEFORE INSERT ON Productos
FOR EACH ROW
BEGIN
    DECLARE v_ExisteReferencia INT;

    -- Verificar si ya existe una referencia igual
    SELECT COUNT(*) INTO v_ExisteReferencia
    FROM Productos
    WHERE Referencia = NEW.Referencia;

    -- Si existe, lanzar un error
    IF v_ExisteReferencia > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya hay un producto con esa referencia, validar información';
    END IF;
END;
//

DELIMITER ;
DELIMITER //

CREATE TRIGGER trg_AfterInsertIngreso
AFTER INSERT ON Ingreso
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Cantidad = Cantidad + 
        (SELECT Cantidad FROM Compra WHERE IdCompra = NEW.IdCompra)
    WHERE IdProducto = NEW.IdProducto;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_AfterInsertSalida
AFTER INSERT ON Salida
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Cantidad = Cantidad - 
        (SELECT Cantidad FROM Venta WHERE IdVenta = NEW.IdVenta)
    WHERE IdProducto = NEW.IdProducto;
END;

//
DELIMITER ;



DELIMITER //

CREATE PROCEDURE spUsuariosInsert(
    IN p_Usuario VARCHAR(50),
    IN p_Contraseña VARCHAR(200),
    IN p_Cargo VARCHAR(50))
CREATE PROCEDURE spUsuariosInsert(
    IN p_Usuario VARCHAR(50),
    IN p_Contraseña VARCHAR(200),
    IN p_Cargo VARCHAR(50))
BEGIN
    -- Cifrar la contraseña con SHA2 (equivalente a SHA256 en MySQL)
    SET @PasswordHash = SHA2(p_Contraseña, 256);
    
    INSERT INTO Usuario (Usuario, Contraseña, Cargo)
    VALUES (p_Usuario, @PasswordHash, p_Cargo);
END //

    -- Cifrar la contraseña con SHA2 (equivalente a SHA256 en MySQL)
    SET @PasswordHash = SHA2(p_Contraseña, 256);
    
    INSERT INTO Usuario (Usuario, Contraseña, Cargo)
    VALUES (p_Usuario, @PasswordHash, p_Cargo);
END //


DELIMITER ;

-- Crear usuario administrador (usuario: admin, contraseña: admin, cargo: admin)
CALL spUsuariosInsert('admin', 'admin', 'admin');


DELIMITER //

CREATE PROCEDURE spUsuariosSetPassword(
    IN p_Usuario VARCHAR(50),
    IN p_OldPassword VARCHAR(200),
    IN p_NewPassword VARCHAR(200)
)
BEGIN
    -- Variables para verificación
    DECLARE v_Coincide INT DEFAULT 0;
    
    -- Verificar si usuario y contraseña actual coinciden
    SELECT COUNT(*) INTO v_Coincide 
    FROM Usuario 
    WHERE Usuario = p_Usuario 
    AND Contraseña = SHA2(p_OldPassword, 256);
    
    -- Si no coinciden, retornar 0
    IF v_Coincide = 0 THEN
        SELECT 0 AS Resultado;
    ELSE
        -- Actualizar la contraseña con el nuevo hash
        UPDATE Usuario 
        SET Contraseña = SHA2(p_NewPassword, 256)
        WHERE Usuario = p_Usuario;
        
        SELECT 1 AS Resultado;
    END IF;
END //

DELIMITER ;

-- Ejemplo de cambio de contraseña ('usuario', 'clave antigua', 'nueva clave')
CALL spUsuariosSetPassword('admin', 'admin', 'admin123');

DELIMITER //

CREATE PROCEDURE spValidarContraseña(
    IN p_Usuario VARCHAR(50),
    IN p_ContraseñaIngresada VARCHAR(200),
    OUT p_Resultado BOOLEAN
)
BEGIN
    DECLARE v_ContraseñaAlmacenada VARCHAR(200);
    
    -- Obtener la contraseña almacenada (ya encriptada)
    SELECT Contraseña INTO v_ContraseñaAlmacenada 
    FROM Usuario 
    WHERE Usuario = p_Usuario;
    
    -- Comparar las contraseñas encriptadas
    IF v_ContraseñaAlmacenada = SHA2(p_ContraseñaIngresada, 256) THEN
        SET p_Resultado = TRUE;
    ELSE
        SET p_Resultado = FALSE;
    END IF;
    
    -- Retornar el resultado
    SELECT p_Resultado AS Validacion;
END //

DELIMITER ;
