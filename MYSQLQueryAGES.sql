-- CREAR BASE DE DATOS
CREATE DATABASE AGES;
USE AGES;

-- CREACIÓN DE TABLAS
-- Tabla Productos: Contiene la información de los productos almacenados.
CREATE TABLE Productos (
    IdProducto INT AUTO_INCREMENT PRIMARY KEY,
   Nombre VARCHAR(50) NOT NULL,
    Alerta INT NOT NULL,
    CantidadActual INT NOT NULL CHECK (CantidadActual >= 0),
    Referencia VARCHAR(50) NOT NULL,
    PrecioBase INT NOT NULL,
    IdCategoria INT NOT NULL,
    CONSTRAINT FK_Productos_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria) ON DELETE CASCADE,
    CONSTRAINT chk_cantidad CHECK (CantidadActual >= 0)
);

-- CREACIÓN DE TABLA CATEGORIA
CREATE TABLE Categoria (
    IdCategoria INT AUTO_INCREMENT PRIMARY KEY,
    NombreCategoria VARCHAR(50) NOT NULL,
    Descripcion TEXT NULL
);


-- Tabla Ingreso: Registra los ingresos de productos asociados a compras.
CREATE TABLE Ingreso (
    IdIngreso INT AUTO_INCREMENT PRIMARY KEY,
    IdProducto INT NOT NULL,
    IdCompra INT NOT NULL,
    CONSTRAINT FK_Ingreso_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE,
    CONSTRAINT FK_Ingreso_Compra FOREIGN KEY (IdCompra) REFERENCES CompraProducto(IdCompra) ON DELETE CASCADE
);

-- Tabla Salida: Registra las salidas de productos relacionados con compras.
CREATE TABLE Salida (
    IdSalida INT AUTO_INCREMENT PRIMARY KEY,
    IdProducto INT NOT NULL,
    IdVenta INT NOT NULL,
    CONSTRAINT FK_Salida_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE,
    CONSTRAINT FK_Salida_Venta FOREIGN KEY (IdVenta) REFERENCES VentaProducto(IdVenta) ON DELETE CASCADE
);

-- Tabla CompraProducto: Registra información sobre las compras realizadas.
CREATE TABLE CompraProducto (
    IdCompra INT AUTO_INCREMENT PRIMARY KEY,
    FechaC DATETIME NOT NULL,
    CantidadC INT NOT NULL,
    ValorUnitarioC INT NOT NULL
);

-- Tabla VentaProducto: Registra información sobre las ventas realizadas.
CREATE TABLE VentaProducto (
    IdVenta INT AUTO_INCREMENT PRIMARY KEY,
    FechaV DATETIME NOT NULL,
    CantidadV INT NOT NULL,
    ValorUnitarioV INT NOT NULL CHECK (ValorUnitarioV >= 0),
    ImpuestoCompra INT NOT NULL,
    CONSTRAINT CHK_PrecioVenta CHECK (ValorUnitarioV >= 0)
);

-- Tabla Usuario: Contiene los usuarios para gestionar el inicio de sesión.
CREATE TABLE Usuario (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(50) NOT NULL,
    Contraseña VARCHAR(200) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Cargo VARCHAR(50) NOT NULL
);

-- ALTER TABLE VentaProducto
-- ADD CONSTRAINT chk_PrecioVentaMayorBase 
-- CHECK (ValorUnitarioV >= (SELECT PrecioBase FROM Productos WHERE IdProducto = IdProducto));


-- CREACIÓN DE ÍNDICES
-- Índices en la tabla Productos
CREATE INDEX IDX_Productos_Nombre ON Productos(Nombre);
CREATE INDEX IDX_Productos_Referencia ON Productos(Referencia);
CREATE INDEX IDX_Productos_CantidadActual ON Productos(CantidadActual);

-- Índices en la tabla Ingreso
CREATE INDEX IDX_Ingreso_ProductoCompra ON Ingreso(IdProducto, IdCompra);

-- Índices en la tabla Salida
CREATE INDEX IDX_Salida_ProductoVenta ON Salida(IdProducto, IdVenta);

-- Índices en la tabla CompraProducto
CREATE INDEX IDX_CompraProducto_FechaCantidad ON CompraProducto(FechaC, CantidadC);

-- Índices en la tabla VentaProducto
CREATE INDEX IDX_VentaProducto_FechaCantidad ON VentaProducto(FechaV, CantidadV);
CREATE INDEX IDX_VentaProducto_ImpuestoCompra ON VentaProducto(ImpuestoCompra);

-- Índices en la tabla Usuario
CREATE UNIQUE INDEX IDX_Usuario_Usuario ON Usuario(Usuario);

-- INSERTAR DATOS DE EJEMPLO
INSERT INTO Categoria (NombreCategoria, Descripcion)
VALUES 
('Guantes de Seguridad', 'Protección para manos en entornos industriales.'),
('Cascos y Protección de Cabeza', 'Cascos para la seguridad en obras y fábricas.'),
('Calzado de Seguridad', 'Botas y zapatos de seguridad para el trabajo.'),
('Ropa de Alta Visibilidad', 'Chalecos y ropa con materiales reflectivos.'),
('Protección Ocular', 'Gafas de seguridad para protección de los ojos.'),
('Equipos de Sujeción', 'Arneses y cinturones de seguridad para trabajos en altura.'),
('Protección Respiratoria', 'Mascarillas y respiradores para entornos contaminados.'),
('Protección Auditiva', 'Dispositivos para la reducción del ruido industrial.'),
('Ropa de Protección', 'Overoles y ropa resistente al fuego y productos químicos.'),
('Señalización y Seguridad', 'Cintas, conos y señalización industrial.');


INSERT INTO Productos (Nombre, Alerta, CantidadActual, Referencia, PrecioBase, IdCategoria)
VALUES 
('Guantes de Seguridad', 10, 50, 'GPROT001', 2000, 1),
('Casco Industrial', 5, 30, 'CSEG002', 4500, 2),
('Botas de Seguridad', 8, 25, 'BIND003', 3500, 3),
('Chaleco Reflectivo', 15, 40, 'CHREF004', 1500, 4),
('Gafas de Protección', 12, 60, 'GFPRO005', 1200, 5),
('Arnés de Seguridad', 7, 20, 'ARNES006', 5000, 6),
('Mascarilla N95', 20, 100, 'MASK007', 300, 7),
('Protector Auditivo', 10, 35, 'PAUD008', 800, 8),
('Overol Antiflama', 5, 15, 'OVFL009', 2500, 9),
('Cinta de Señalización', 30, 80, 'CTSIG010', 100, 10);


INSERT INTO CompraProducto (FechaC, CantidadC, ValorUnitarioC)
VALUES 
('2023-10-01 08:00:00', 20, 5000),
('2023-10-02 09:30:00', 15, 7000),
('2023-10-03 10:15:00', 10, 6000),
('2023-10-04 11:45:00', 25, 5500),
('2023-10-05 12:30:00', 30, 8000),
('2023-10-06 14:00:00', 12, 4500),
('2023-10-07 15:20:00', 18, 7500),
('2023-10-08 16:10:00', 22, 6500),
('2023-10-09 17:30:00', 14, 9000),
('2023-10-10 18:45:00', 16, 8500);

INSERT INTO VentaProducto (FechaV, CantidadV, ValorUnitarioV, ImpuestoCompra)
VALUES 
('2023-10-01 09:00:00', 5, 5500, 10),
('2023-10-02 10:30:00', 10, 7500, 15),
('2023-10-03 11:45:00', 8, 6500, 12),
('2023-10-04 12:15:00', 12, 6000, 10),
('2023-10-05 13:30:00', 15, 8500, 18),
('2023-10-06 14:45:00', 7, 5000, 10),
('2023-10-07 15:30:00', 9, 8000, 15),
('2023-10-08 16:20:00', 11, 7000, 12),
('2023-10-09 17:10:00', 6, 9500, 20),
('2023-10-10 18:00:00', 13, 9000, 18);

INSERT INTO Ingreso (IdProducto, IdCompra)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

INSERT INTO Salida (IdProducto, IdVenta)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- TRIGGERS
-- Trigger para incrementar la cantidad al realizar una compra
DELIMITER //

CREATE TRIGGER trg_AfterInsertIngreso
AFTER INSERT ON Ingreso
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET CantidadActual = CantidadActual + 
        (SELECT CantidadC FROM CompraProducto WHERE IdCompra = NEW.IdCompra)
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
    SET CantidadActual = CantidadActual - 
        (SELECT CantidadV FROM VentaProducto WHERE IdVenta = NEW.IdVenta)
    WHERE IdProducto = NEW.IdProducto;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_UpdatePrecioBase
AFTER INSERT ON CompraProducto
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET PrecioBase = NEW.ValorUnitarioC
    WHERE IdProducto = (SELECT IdProducto FROM Ingreso WHERE IdCompra = NEW.IdCompra LIMIT 1);
END;

//

DELIMITER ;
