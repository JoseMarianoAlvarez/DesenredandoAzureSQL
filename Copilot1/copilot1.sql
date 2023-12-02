-- sql server
-- creo una tabla de tipos de clientes
CREATE TABLE tipo_cliente (
    id_tipo_cliente INT NOT NULL IDENTITY(1,1),
    nombre_tipo_cliente VARCHAR(45) NOT NULL,
    PRIMARY KEY (id_tipo_cliente)
);
GO

-- el nombre del tipo de cliente debe ser unico
ALTER TABLE tipo_cliente ADD CONSTRAINT nombre_tipo_cliente UNIQUE (nombre_tipo_cliente);
GO

-- lleno la tabla con 5 tipos de clientes
INSERT INTO tipo_cliente (nombre_tipo_cliente) VALUES ('Consumidor Final');
INSERT INTO tipo_cliente (nombre_tipo_cliente) VALUES ('Responsable Inscripto');
INSERT INTO tipo_cliente (nombre_tipo_cliente) VALUES ('Monotributista');
INSERT INTO tipo_cliente (nombre_tipo_cliente) VALUES ('Exento');
INSERT INTO tipo_cliente (nombre_tipo_cliente) VALUES ('No Responsable');
GO


--creo una tabla de clientes con una clave foranea a la tabla tipo_cliente
-- con nombre de cliente, email, direccion, id_tipo_cliente , cuit
-- el cuit y el nombre de cliente son unicos
CREATE TABLE cliente (
    id_cliente INT NOT NULL IDENTITY(1,1),
    nombre_cliente VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    id_tipo_cliente INT NOT NULL,
    cuit VARCHAR(45) NOT NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE (nombre_cliente),
    UNIQUE (cuit),
    FOREIGN KEY (id_tipo_cliente) REFERENCES tipo_cliente(id_tipo_cliente)
);
GO

-- lleno la tabla con 5 clientes
INSERT INTO cliente (nombre_cliente, email, direccion, id_tipo_cliente, cuit) 
VALUES 
    ('Juan Perez','juanperez@correo.com','Calle 123',1,'20-12345678-9'), 
    ('Maria Lopez','mariolopez@correo.com','Calle 456',2,'20-23456789-0'), 
    ('Pedro Gomez','pedrogomez@correo.com','Calle 789',3,'20-34567890-1'), 
    ('Jose Gonzalez','josegonzalez@correo.com','Calle 012',4,'20-45678901-2'), 
    ('Ana Fernandez','anafernandez@correo.com','Calle 345',5,'20-56789012-3');
go
select * from cliente


-- creo una tabla de tipos de productos
CREATE TABLE tipo_producto (
    id_tipo_producto INT NOT NULL IDENTITY(1,1),
    nombre_tipo_producto VARCHAR(45) NOT NULL,
    PRIMARY KEY (id_tipo_producto)
);
GO

-- el nombre de tipo de producto debe ser unico
ALTER TABLE tipo_producto ADD CONSTRAINT nombre_tipo_producto UNIQUE (nombre_tipo_producto);
GO


--lleno la tabla con 3 tipos de productos
INSERT INTO tipo_producto (nombre_tipo_producto) VALUES ('Alimento');
INSERT INTO tipo_producto (nombre_tipo_producto) VALUES ('Bebida');
INSERT INTO tipo_producto (nombre_tipo_producto) VALUES ('Limpieza');
GO


-- creo una tabla de productos con una clave foranea a la tabla tipo_producto
-- con nombre de producto, precio, id_tipo_producto
-- el nombre de producto es unico
CREATE TABLE producto (
    id_producto INT NOT NULL IDENTITY(1,1),
    nombre_producto VARCHAR(45) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_tipo_producto INT NOT NULL,
    PRIMARY KEY (id_producto),
    UNIQUE (nombre_producto),
    FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto)
);
GO

--lleno la tabla con 10 productos
INSERT INTO producto (nombre_producto, precio, id_tipo_producto)
VALUES 
    ('Arroz', 100.00, 1),
    ('Fideos', 80.00, 1),
    ('Pan', 50.00, 1),
    ('Leche', 120.00, 2),
    ('Agua', 70.00, 2),
    ('Coca Cola', 150.00, 2),
    ('Jabon', 90.00, 3),
    ('Detergente', 110.00, 3),
    ('Lavandina', 60.00, 3),
    ('Desodorante', 130.00, 3); 
GO


-- creo una tabla de pedidos con una clave foranea a la tabla cliente
-- con fecha de pedido, id_cliente
CREATE TABLE pedido (
    id_pedido INT NOT NULL IDENTITY(1,1),
    fecha_pedido DATE NOT NULL,
    id_cliente INT NOT NULL,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);
GO

-- creo una tabla de detalle de pedidos con una clave foranea a la tabla pedido y producto
-- con id_pedido, id_producto, cantidad
CREATE TABLE detalle_pedido (
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
GO


set nocount on;

-- creo dos WHILE anidados para insertar de forma aleatoria 100 pedidos
-- los pedidos se realizan entre el 1 de enero de 2020 y el 31 de diciembre de 2020
-- los productos se eligen de forma aleatoria
-- la cantidad de productos se elige de forma aleatoria entre 1 y 5
-- la cantidad de cada producto se elige de forma aleatoria entre 1 y 10
DECLARE @fecha_pedido DATE;
DECLARE @id_cliente INT;
DECLARE @id_producto INT;
DECLARE @cantidad INT;
DECLARE @cantidad_productos INT;
DECLARE @contador_productos INT;
DECLARE @fecha_inicio DATE = '2020-01-01';
DECLARE @fecha_fin DATE = '2020-12-31';
DECLARE @id_pedido INT; 

-- cuento de 1 a 100 pedidos
DECLARE @contador_pedidos INT = 1;
WHILE @contador_pedidos <= 100
BEGIN
    -- genero una fecha aleatoria entre el 1 de enero de 2020 y el 31 de diciembre de 2020
    SET @fecha_pedido = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, @fecha_inicio, @fecha_fin), @fecha_inicio);
    -- genero un id de cliente aleatorio entre 1 y 5
    SET @id_cliente = ABS(CHECKSUM(NEWID())) % 5 + 1;
    -- inserto el pedido
    INSERT INTO pedido (fecha_pedido, id_cliente) VALUES (@fecha_pedido, @id_cliente);
    -- obtengo el id del pedido insertado
    SET @id_pedido = SCOPE_IDENTITY();
    -- genero una cantidad aleatoria de productos entre 1 y 5
    SET @cantidad_productos = ABS(CHECKSUM(NEWID())) % 5 + 1;
    -- cuento de 1 a la cantidad de productos
    SET @contador_productos = 1;
    WHILE @contador_productos <= @cantidad_productos
    BEGIN
        -- genero un id de producto aleatorio entre 1 y 10
        SET @id_producto = ABS(CHECKSUM(NEWID())) % 10 + 1;
        -- genero una cantidad aleatoria entre 1 y 10
        SET @cantidad = ABS(CHECKSUM(NEWID())) % 10 + 1;
        
        -- si no existe la combinacion de id_pedido e id_producto en la tabla detalle_pedido
        IF NOT EXISTS (SELECT * FROM detalle_pedido WHERE id_pedido = @id_pedido AND id_producto = @id_producto)
        BEGIN
            -- inserto el detalle del pedido
            INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad) 
            VALUES (@id_pedido, @id_producto, @cantidad);
        END



        -- incremento el contador de productos
        SET @contador_productos = @contador_productos + 1;
    END
    -- incremento el contador de pedidos
    SET @contador_pedidos = @contador_pedidos + 1;
END
go



select * from pedido
select * from detalle_pedido

delete from detalle_pedido
delete from pedido

--elimino las tablas
drop table detalle_pedido
drop table pedido
drop table producto
drop table tipo_producto
drop table cliente
drop table tipo_cliente
go





-- obtengo la cantidad de pedidos con alimentos para los clientes con tipo de Monotributista
select count(*) as cantidad_pedidos_alimentos
from pedido p
inner join detalle_pedido dp on dp.id_pedido = p.id_pedido
inner join producto pr on pr.id_producto = dp.id_producto
inner join tipo_producto tp on tp.id_tipo_producto = pr.id_tipo_producto
inner join cliente c on c.id_cliente = p.id_cliente
inner join tipo_cliente tc on tc.id_tipo_cliente = c.id_tipo_cliente
where tp.nombre_tipo_producto = 'Alimento' 
and tc.nombre_tipo_cliente = 'Monotributista'



