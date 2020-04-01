CREATE DATABASE VentaVehiculos;
go

use VentaVehiculos
go

create table TipoUser
(
    idTipoUser  smallint identity (1,1) primary key,
    descripcion varchar(20) not null
)

begin tran
    insert into TipoUser values ('Administrador')
    insert into TipoUser values ('Vendedor')
    insert into TipoUser values ('Cliente')
commit

select *
from TipoUser


create table Provincias
(
    idProvincia int primary key,
    nombre      varchar(45) not null
)

begin tran
    INSERT INTO Provincias
    VALUES (1, 'Azua')
         , (2, 'Bahoruco')
         , (3, 'Barahona')
         , (4, 'Dajabón')
         , (5, 'Distrito Nacional')
         , (6, 'Duarte')
         , (7, 'Elías Piña')
         , (8, 'El Seibo')
         , (9, 'Espaillat')
         , (10, 'Hato Mayor')
         , (11, 'Hermanas Mirabal')
         , (12, 'Independencia')
         , (13, 'La Altagracia')
         , (14, 'La Romana')
         , (15, 'La Vega')
         , (16, 'María Trinidad Sánchez')
         , (17, 'Monseñor Nouel')
         , (18, 'Monte Cristi')
         , (19, 'Monte Plata')
         , (20, 'Pedernales')
         , (21, 'Peravia')
         , (22, 'Puerto Plata')
         , (23, 'Samaná')
         , (24, 'Sánchez Ramírez')
         , (25, 'San Cristóbal')
         , (26, 'San José de Ocoa')
         , (27, 'San Juan')
         , (28, 'San Pedro de Macorís')
         , (29, 'Santiago')
         , (30, 'Santiago Rodríguez')
         , (31, 'Santo Domingo')
         , (32, 'Valverde')
commit

create table Users
(
    usuario    varchar(32) primary key,
    idTipoUser smallint foreign key references TipoUser (idTipoUser),
    clave      varchar(40) not null
)

create table Cliente
(
    idCliente bigint identity (1,1) primary key
)

create table TipoVendedor
(
    idTipoVendedor smallint identity (1,1) primary key,
    descripcion    varchar(20) not null
)

begin tran
    insert into TipoVendedor values ('Dealer')
    insert into TipoVendedor values ('Particular')
commit

create table Vendedor
(
    idVendedor     bigint identity (1,1) primary key,
    idTipoVendedor smallint foreign key references TipoVendedor (idTipoVendedor)
)

create table Persona
(
    idPersona   bigint identity (1,1) primary key,
    cedula      varchar(11),
    nombre      varchar(25),
    apellido    varchar(30),
    idProvincia int foreign key references Provincias (idProvincia) not null,
    numero      varchar(10)                                             not null,
    usuario     varchar(32) foreign key references Users (usuario) not  null,
    idVendedor  bigint foreign key references Vendedor (idVendedor)     null,
    idCliente   bigint foreign key references Cliente (idCliente)       null,
    autorizado  smallint,
    email       varchar(62)
)

alter table Persona
    add unique (cedula)

alter table Users
    add idPersona bigint

alter table Users
    with check
        add constraint fkIdPers
        foreign key (idPersona) references Persona (idPersona)

alter table Cliente
    add idPersona bigint

alter table Cliente
    with check
        add constraint fkClienteCedula
        foreign key (idPersona) references Persona (idPersona)

alter table Vendedor
    add idPersona bigint

alter table Vendedor
    with check
        add constraint fkVendedorCedula
        foreign key (idPersona) references Persona (idPersona)

create table Anuncio
(
    idAnuncio   bigint identity (1,1) primary key,
    decripcion  varchar(70),
    costo       money                                                   not null,
    fechaInicio datetime                                                not null,
    fechaFin    datetime                                                not null,
    autorizado  smallint                                                not null,
    idVendedor  bigint foreign key references Vendedor (idVendedor) not null,
    idVehiculo  bigint
)

create table Modelo
(
    idModelo bigint identity (1,1) primary key,
    nombre   varchar(32) not null
)

create table TipoVehiculo
(
    idTipoVehiculo smallint identity (1,1) primary key,
    descripcion    varchar(32) not null
)

begin tran
    insert into TipoVehiculo values ('Sedán')
    insert into TipoVehiculo values ('Motor')
    insert into TipoVehiculo values ('Compacto')
    insert into TipoVehiculo values ('Camión')
    insert into TipoVehiculo values ('Jeepeta')
    insert into TipoVehiculo values ('Barco')
    insert into TipoVehiculo values ('Camioneta')
    insert into TipoVehiculo values ('Autobus')
    insert into TipoVehiculo values ('Coupé')
    insert into TipoVehiculo values ('Vehículo Pesado')
    insert into TipoVehiculo values ('Otro')
commit

create table Marca
(
    idMarca  bigint identity (1,1) primary key,
    idModelo bigint foreign key references Modelo (idModelo) null
)

create table Vehiculo
(
    idVehiculo     bigint identity (1,1) primary key,
    estado         varchar(20),
    anio           int                                               not null,
    idMarca        bigint foreign key references Marca (idMarca),
    idModelo       bigint foreign key references Modelo (idModelo),
    idTipoVehiculo smallint foreign key references TipoVehiculo (idTipoVehiculo),
    idAnuncio      bigint foreign key references Anuncio (idAnuncio) null
)

Create table ClienteCompraVehiculo
(
    idCliente   bigint   not null,
    idVehiculo  bigint   not null,
    fechaCompra datetime not null

        constraint primarykeys primary key clustered
            (
             idCliente,
             idVehiculo
                )
)

alter table ClienteCompraVehiculo
    with check
        add constraint addingFks1
        foreign key (idCliente)
            references Cliente (idCliente)

alter table ClienteCompraVehiculo
    with check
        add constraint addingFks2
        foreign key (idVehiculo)
            references Vehiculo (idVehiculo)