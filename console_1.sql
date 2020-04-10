-- create database VentaVehiculo collate Modern_Spanish_CI_AS
-- go

use VentaVehiculo;

create table Empresa
(
    idEmpresa   int identity
        constraint PK_Empresa primary key,
    nombre      varchar(50),
    descripcion varchar(100)
)
go

create table Usuario
(
    usuario    varchar(50)
        constraint PK_Usurio
            primary key,
    contrasena char(32),
)
go

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

INSERT INTO Empresa(nombre, descripcion)
VALUES ('Individual', 'Persona individual');

create table VendedorUsuario
(
    idEmpresa  int foreign key references Empresa (idEmpresa),
    idVendedor varchar(50) foreign key references Persona (cedula),
    CONSTRAINT PK_VendedorUsuario primary key (idEmpresa, idVendedor)
)

create table Admin
(
    usuario varchar(50) foreign key references Persona (cedula),
    CONSTRAINT PK_Admin primary key (usuario)
)

create table EstadoVehiculo
(
    nombre varchar(10)
        constraint PK_EstadoVehiculo primary key
)
go

INSERT INTO EstadoVehiculo(nombre)
VALUES ('Nuevo'),
       ('Usado');
go

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
    descripcion varchar(50)
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
    descripcion    varchar(50)
)
go

create table Ciudad
(
    idCiudad int identity constraint PK_Ciudad primary key,
    nombre varchar(32)
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
    Fecha       date,
    Precio      float,
    Estado      bit,
    idCiudad      int foreign key references Ciudad (idCiudad),
    descripcion varchar(255)
)
go

create table Ventas
(
    IdVenta    int identity
        constraint PK_Ventas
            primary key,
    idCliente  varchar(50) foreign key references Persona (Cedula),
    idVendedor varchar(50) foreign key references Persona (Cedula),
    IdVehiculo int foreign key references Vehiculo (idVehiculo),
    Fecha      date
)
go

CREATE PROCEDURE SP_NuevoUsuario @User varchar(50), @Pass char(32), @Cedula varchar(50), @Nombre varchar(50),
                                 @Apellido varchar(50), @Direccion varchar(100), @Email varchar(50)
AS
BEGIN
    INSERT INTO Usuario(usuario, contrasena) VALUES (@User, @Pass);
    INSERT INTO Persona(cedula, nombre, apellido, direccion, email, usuario)
    VALUES (@Cedula, @Nombre, @Apellido, @Direccion, @Email, @User);
END


-- CREATE LOGIN VehiculoWebApp
--     WITH PASSWORD = N'zP&hK*!4Mu5JMj#Wv^*.y+c-S6qXg.k]';
-- go
--
-- CREATE USER VehiculoWebApp FOR LOGIN VehiculoWebApp;
-- go
--
-- GRANT CONTROL ON DATABASE :: VentaVehiculo TO VehiculoWebApp;
