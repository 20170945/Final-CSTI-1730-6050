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
    descripcion varchar(255),
    aprobado    bit
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

CREATE VIEW VehiculoConDetalles AS
SELECT idVehiculo,
       M.idMarca,
       M2.nombre as nombreMarca,
       Vehiculo.idModelo,
       M.nombre  as nombreModelo,
       M.ano,
       Precio,
       Fecha,
       Nuevo,
       Vehiculo.idCiudad,
       C.nombre  as Ciudad,
       Vehiculo.descripcion,
       aprobado
FROM Vehiculo
         INNER JOIN Modelo M on Vehiculo.idModelo = M.idModelo
         INNER JOIN Marca M2 on M.idMarca = M2.idMarca
         INNER JOIN Ciudad C on Vehiculo.idCiudad = C.idCiudad;

CREATE VIEW Catalogo AS
SELECT fechaPublicacion, V.idVehiculo, idMarca, idModelo, nombreMarca+' '+nombreModelo as nombre, ano, Precio, idCiudad, dbo.getTipoDeModelo(idModelo) as idTipo, descripcion
FROM VehiculoConDetalles V
         INNER JOIN (SELECT *
                     FROM Anuncio a
                     WHERE fechaExpiracion > GETDATE()
                       AND a.idVehiculo NOT IN (SELECT d.idVehiculo FROM Ventas d)) as A
                    ON A.idVehiculo = V.idVehiculo;
go

--Stored Procedures
CREATE PROCEDURE SP_RegistrarVenta @idEmpresa int, @idVendedor varchar(50), @idCliente varchar(50), @idVehiculo int
as
BEGIN
    INSERT INTO Ventas(idEmpresa, idCliente, idVendedor, idVehiculo, Fecha)
    VALUES (@idEmpresa, @idCliente, @idVendedor, @idVehiculo, GETDATE());
END;
go

CREATE PROCEDURE SP_RegistrarVehiculo @idEmpresa int, @idPublicador varchar(50), @idModelo int, @Precio float,
                                      @Nuevo bit, @IdCiudad int, @Descripcion varchar(255)
as
BEGIN
    INSERT INTO Vehiculo(idModelo, Precio, Fecha, Nuevo, idCiudad, descripcion)
    VALUES (@idModelo, @Precio, GETDATE(), @Nuevo, @IdCiudad, @Descripcion);
    DECLARE @idVehiculo int;
    SELECT @idVehiculo = MAX(idVehiculo) FROM Vehiculo;
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

CREATE FUNCTION getTipoDeModelo(@idModelo int)
    returns int
as
begin
    DECLARE @ans int;
    SELECT @ans = idTipoVehiculo FROM Modelo WHERE idModelo = @idModelo;
    if (@ans IS NULL)
        set @ans = -1;
    return @ans;
end;
go

CREATE FUNCTION getNameTipoDeModelo(@idModelo int)
    returns varchar(20)
as
begin
    DECLARE @ans varchar(20);
    SELECT @ans = nombre FROM TipoVehiculo WHERE idTipoVehiculo = dbo.getTipoDeModelo(@idModelo);
    if (@ans IS NULL)
        set @ans = 'null';
    return @ans;
end;
go

CREATE FUNCTION getVendedorEmpresa(@usuario varchar(50))
    RETURNS int
AS
BEGIN
    DECLARE @ans int;
    SELECT @ans = idEmpresa FROM VendedorUsuario WHERE cedulaVendedor = dbo.getUserCedula(@usuario);
    if (@ans IS NULL)
        set @ans = -1;
    RETURN @ans;
END;
go

CREATE FUNCTION cantModelo(@idMarca int)
    RETURNS int
AS
BEGIN
    DECLARE @ans int;
    SELECT @ans = COUNT(*) FROM Modelo WHERE idMarca = @idMarca GROUP BY idMarca;
    if (@ans IS NULL)
        set @ans = 0;
    RETURN @ans;
END;
go

CREATE FUNCTION getCarrosDeEmpresa(@idEmpresa int)
    RETURNS TABLE AS RETURN
            (
                SELECT ROW_NUMBER() over (ORDER BY OV.idVehiculo) as idRow,
                       OV.idVehiculo,
                       idEmpresa,
                       idPublicador,
                       M2.nombre                                  as Marca,
                       M.nombre                                   as Modelo,
                       M.ano
                FROM Vehiculo
                         INNER JOIN OwnerVehiculo OV on Vehiculo.idVehiculo = OV.idVehiculo
                         INNER JOIN Modelo M on Vehiculo.idModelo = M.idModelo
                         INNER JOIN Marca M2 on M.idMarca = M2.idMarca
                WHERE idEmpresa = @idEmpresa
                  AND aprobado = 1
            );
go

CREATE FUNCTION getCarrosDeIndividual(@cedula varchar(50))
    RETURNS TABLE AS RETURN
            (
                SELECT ROW_NUMBER() over (ORDER BY OV.idVehiculo) as idRow,
                       OV.idVehiculo,
                       idEmpresa,
                       idPublicador,
                       M2.nombre                                  as Marca,
                       M.nombre                                   as Modelo,
                       M.ano
                FROM Vehiculo
                         INNER JOIN OwnerVehiculo OV on Vehiculo.idVehiculo = OV.idVehiculo
                         INNER JOIN Modelo M on Vehiculo.idModelo = M.idModelo
                         INNER JOIN Marca M2 on M.idMarca = M2.idMarca
                WHERE idPublicador = @cedula
                  AND aprobado = 1
            );
go

-- PRESET u'admin' P'1234'
EXEC SP_NuevoUsuario 'admin', '81DC9BDB52D04DC20036DBD8313ED055', '1', 'Administrador', 'Sistema', '', '', 1;
go

INSERT INTO Admin(usuario)
VALUES ('admin');
go

DELETE
FROM Usuario
WHERE verificado = 0;
go