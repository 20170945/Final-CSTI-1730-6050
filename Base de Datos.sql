-- CREATE DATABASE VentaVehiculos;
-- go

USE VentaVehiculos;

CREATE LOGIN VehiculoWebApp
    WITH PASSWORD = 'jy=ZzmPe4kAJd^su';
go

CREATE USER VehiculoWebApp FOR LOGIN VehiculoWebApp;
go

GRANT CONTROL ON DATABASE :: VentaVehiculos TO VehiculoWebApp;