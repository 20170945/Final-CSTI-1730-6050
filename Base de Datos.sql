-- CREATE DATABASE VentaVehiculos;
-- go

USE VentaVehiculos;

CREATE LOGIN VehiculoWebApp
    WITH PASSWORD = N'zP&hK*!4Mu5JMj#Wv^*.y+c-S6qXg.k]';
go

CREATE USER VehiculoWebApp FOR LOGIN VehiculoWebApp;
go

GRANT CONTROL ON DATABASE :: VentaVehiculos TO VehiculoWebApp;