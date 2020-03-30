CREATE DATABASE Vehiculos;
go

USE Vehiculos;

CREATE LOGIN VehiculoWebApp
    WITH PASSWORD = 'jy=ZzmPe4kAJd^su';
go

CREATE USER VehiculoWebApp FOR LOGIN VehiculoWebApp;
go

GRANT CONTROL ON DATABASE :: Vehiculos TO VehiculoWebApp;