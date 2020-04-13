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
