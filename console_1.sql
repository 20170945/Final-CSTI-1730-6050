-- create database VentaVehiculo collate Modern_Spanish_CI_AS
-- go

use VentaVehiculo;

-- CREATE LOGIN VehiculoWebApp
--     WITH PASSWORD = N'zP&hK*!4Mu5JMj#Wv^*.y+c-S6qXg.k]';
-- go
--
-- CREATE USER VehiculoWebApp FOR LOGIN VehiculoWebApp;
-- go
--
-- GRANT CONTROL ON DATABASE :: VentaVehiculo TO VehiculoWebApp;

create table Empresa
(
    idEmpresa   int identity
        constraint PK_Empresa primary key,
    nombre      varchar(50),
    direccion   varchar(100),
    descripcion varchar(256)
)
go

INSERT INTO Empresa(nombre, direccion, descripcion)
VALUES ('Individual', '', 'Persona individual');

create table Usuario
(
    usuario    varchar(50)
        constraint PK_Usurio
            primary key,
    contrasena char(32),
)
go

create table Admin
(
    usuario varchar(50) foreign key references Usuario (usuario),
    CONSTRAINT PK_Admin primary key (usuario)
)

create table Persona
(
    cedula    varchar(50)  not null
        constraint PK_Persona
            primary key,
    nombre    varchar(50)  not null,
    apellido  varchar(50)  not null,
    direccion varchar(100) not null,
    email     varchar(50),
    usuario   varchar(50) foreign key REFERENCES Usuario (usuario)
)
go

create table VendedorUsuario
(
    idEmpresa      int foreign key references Empresa (idEmpresa),
    cedulaVendedor varchar(50) foreign key references Persona (cedula),
    CONSTRAINT PK_VendedorUsuario primary key (cedulaVendedor)
)

CREATE TABLE TipoVehiculo
(
    idTipoVehiculo int identity
        constraint PK_TipoVehiculo primary key,
    nombre         varchar(20)
)
go

INSERT INTO TipoVehiculo(nombre)
VALUES ('Sedán'),
       ('Motor'),
       ('Compacto'),
       ('Barcos'),
       ('Jeepeta'),
       ('Camión'),
       ('Camioneta'),
       ('AutoBus'),
       ('Deportivo'),
       ('Pesado'),
       ('Otro');
go

create table Marca
(
    idMarca     int identity
        constraint Marca_pk
            primary key nonclustered,
    nombre      varchar(20),
    descripcion varchar(256)
)
go

create table Modelo
(
    idModelo       int identity
        constraint Modelo_pk
            primary key nonclustered,
    idMarca        int foreign key references Marca (idMarca),
    idTipoVehiculo int foreign key references TipoVehiculo (idTipoVehiculo),
    nombre         varchar(20),
    ano            int,
    descripcion    varchar(256)
)
go

create table Ciudad
(
    idCiudad int identity
        constraint PK_Ciudad primary key,
    nombre   varchar(32)
)
go

INSERT INTO Ciudad(nombre)
VALUES ('Distrito Nacional'),
       ('Santo Domingo Este'),
       ('Santiago de los Caballeros'),
       ('Santo Domingo Norte'),
       ('Santo Domingo Oeste'),
       ('Higuey'),
       ('San Cristóbal'),
       ('San Pedro Macorís'),
       ('San Francisco de Macorís'),
       ('Concepción de La Vega'),
       ('Boca chica'),
       ('San Felipe de Puerto Plata'),
       ('La Romana'),
       ('Santa Cruz de Barahona'),
       ('Baní'),
       ('San Juan de la Maguana'),
       ('Bonao'),
       ('Moca'),
       ('Azua de Compostela'),
       ('Cotuí'),
       ('Santa Cruz de El Seibo'),
       ('Jarabacoa'),
       ('Nagua'),
       ('Santa Bárbara de Samaná'),
       ('Tamboril'),
       ('Mao'),
       ('Esperanza'),
       ('Pedro Brand'),
       ('Sosúa'),
       ('Hato Mayor del Rey'),
       ('Constanza'),
       ('Villa Bisonó'),
       ('Salcedo'),
       ('Villa Altagracia'),
       ('Las Matas de Farfán'),
       ('Monte Plata'),
       ('Yamasá'),
       ('San Ignacio de Sabaneta'),
       ('San José de Las Matas'),
       ('San Antonio de Guerra'),
       ('San José de Ocoa');

create table Vehiculo
(
    idVehiculo  int identity
        constraint PK_Vehiculo primary key,
    idModelo    int foreign key references Modelo (idModelo),
    Precio      float,
    Fecha       date,
    Nuevo       bit,
    idCiudad    int foreign key references Ciudad (idCiudad),
    descripcion varchar(255)
)
go

create table OwnerVehiculo
(
    idVehiculo   int foreign key references Vehiculo (idVehiculo),
    idEmpresa    int foreign key references Empresa (idEmpresa),
    idPublicador varchar(50) foreign key references Persona (Cedula),
    CONSTRAINT PK_OwnerVehiculo primary key (idVehiculo)
)

create table Ventas
(
    IdVenta    int identity
        constraint PK_Ventas
            primary key,
    idEmpresa  int foreign key references Empresa (idEmpresa),
    idCliente  varchar(50) foreign key references Persona (Cedula),
    idVendedor varchar(50) foreign key references Persona (Cedula),
    idVehiculo int foreign key references Vehiculo (idVehiculo),
    Fecha      date
)
go

create table Anuncio
(
    idAnuncio        int identity
        constraint Anuncio_pk
            primary key nonclustered,
    idVehiculo       int foreign key references Vehiculo (idVehiculo),
    fechaPublicacion date,
    fechaExpiracion  date,
    estado           char
)
go

create table PedidoAnuncio
(
    idVehiculo int foreign key references Vehiculo (idVehiculo),
    dias       int,
    CONSTRAINT PK_PedidoAnuncio primary key (idVehiculo)

)


--Vistas
CREATE VIEW ModeloConTipo AS
SELECT idModelo, idMarca, Modelo.idTipoVehiculo, TV.nombre as tipoNombre, Modelo.nombre, ano, descripcion
FROM Modelo
         left join TipoVehiculo TV on Modelo.idTipoVehiculo = TV.idTipoVehiculo;
go

CREATE VIEW PersonaUsuario AS
SELECT cedula, nombre, apellido, email, Persona.usuario, U.verificado
FROM Persona
         INNER JOIN Usuario U on Persona.usuario = U.usuario;
go


--Stored Procedures
CREATE PROCEDURE SP_RegistrarVehiculo @idEmpresa int, @idPublicador varchar(50), @idModelo int, @Precio float,
                                      @Nuevo bit, @IdCiudad int, @Descripcion varchar(255)
as
BEGIN
    INSERT INTO Vehiculo(idModelo, Precio, Fecha, Nuevo, idCiudad, descripcion) VALUES (@idModelo, @Precio, GETDATE(), @Nuevo, @IdCiudad, @Descripcion);
    DECLARE @idVehiculo int;
    SELECT @idVehiculo=MAX(idVehiculo) FROM Vehiculo;
    INSERT INTO OwnerVehiculo(idVehiculo, idEmpresa, idPublicador) VALUES (@idVehiculo, @idEmpresa, @idPublicador);
END;
go

CREATE PROCEDURE SP_NuevoUsuario @User varchar(50), @Pass char(32), @Cedula varchar(50), @Nombre varchar(50),
                                 @Apellido varchar(50), @Direccion varchar(100), @Email varchar(50), @Verificado bit
AS
BEGIN
    INSERT INTO Usuario(usuario, contrasena, verificado) VALUES (@User, @Pass, @Verificado);
    INSERT INTO Persona(cedula, nombre, apellido, direccion, email, usuario)
    VALUES (@Cedula, @Nombre, @Apellido, @Direccion, @Email, @User);
END;
go



--Funciones
CREATE FUNCTION getUserCedula(@usuario varchar(50))
    RETURNS varchar(50)
AS
BEGIN
    DECLARE @ans varchar(50);
    SELECT @ans = cedula FROM Persona WHERE usuario = @usuario;
    if (@ans IS NULL)
        set @ans = ' ';
    RETURN @ans;
END;
go

CREATE FUNCTION getVendedorEmpresa(@usuario varchar(50))
    RETURNS int
AS
BEGIN
    DECLARE @ans int;
    SELECT @ans=idEmpresa FROM VendedorUsuario WHERE cedulaVendedor=dbo.getUserCedula(@usuario);
    if (@ans IS NULL)
        set @ans = -1;
    RETURN @ans;
END;
go

-- PRESET
EXEC SP_NuevoUsuario 'admin', '81DC9BDB52D04DC20036DBD8313ED055', '1', 'Administrador', 'Sistema', '', '', 1;
go

INSERT INTO Admin(usuario)
VALUES ('admin');
go

DELETE
FROM Usuario
WHERE verificado = 0;
go


--TODO Consultas y Funciones
-- Consulta general de vehículos en venta ordenado por fecha.
SELECT *
FROM Vehiculo
WHERE idVehiculo NOT IN (SELECT Ventas.idVehiculo FROM Ventas)
ORDER BY Fecha;
-- Consulta de vendedores indicado tipo (empresa o persona física) y cantidad de anuncios publicados.

-- Consulta general de usuarios (clientes).
SELECT *
FROM Persona
WHERE cedula IN (SELECT Ventas.idCliente FROM Ventas)
-- Consulta de venta por año, mes, marca, ciudad.
-- Consulta de publicación indicando costo, tiempo de publicación.
-- Consulta de vendedores con mayor venta de vehículos.
-- Función que actualice el estado del anuncio de disponible (D) a vendido (V).
CREATE PROCEDURE SP_AnuncioVendido @idAnuncio int as
BEGIN
    UPDATE Anuncio SET estado='V' WHERE idAnuncio = @idAnuncio;
END;
go
-- Función que ingrese una publicación de anuncio.
Create procedure AgregarAnuncio @IDVehiculo int,
                                @FechaPublicacion datetime,
                                @FechaExpiracion datetime,
                                @Estado char
As
Begin
    Insert into Anuncio(IDVehiculo, FechaPublicacion, FechaExpiracion, Estado)
    Values (@IDVehiculo, @FechaPublicacion, @FechaExpiracion, @Estado)
End;
go
-- Función que elimine una publicación de anuncio.
Create procedure EliminarAnuncio @idAnuncio int
As

Begin
    Delete from Anuncio where idAnuncio = @idAnuncio
End
go
-- Función que muestre los vehículos por marca (se debe enviar la marca como parámetro).
CREATE FUNCTION vehiculosPorMarca(@marca int)
    RETURNS TABLE
        AS RETURN
            (
                SELECT *
                FROM Vehiculo
                         INNER JOIN Modelo M on Vehiculo.idModelo = M.idModelo
                WHERE M.idMarca = @marca
            );
go
