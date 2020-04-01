use VentaVehiculos
go

--create procedure registrarUsuario
--@signid varchar(20),
--@tipo varchar(3),
--@clave varchar(30)
--as
--begin tran
--insert into Users values (@signid, convert(smallint @tipo), @clave, null)
--commit
------------------------------------------------------------------------------------------

create procedure registrarCliente
@usuario varchar(50),
@tipoUser varchar(3),
@clave varchar(30),
@cedula varchar(11),
@nombre varchar(50),
@apellido varchar(50),
@provincia varchar(3),
@email varchar(62),
@numero varchar(10)
as
begin tran
insert into Users
(
	usuario,
	idTipoUser,
	clave
)
values
(
	@usuario,
	convert(smallint, @tipoUser),
	@clave
)


insert into Persona
(
	cedula,
	nombre,
	apellido,
	idProvincia,
	numero,
	usuario,
	autorizado,
	email
)
values
(
	@cedula,
	@nombre,
	@apellido,
	convert(int, @provincia),
	@numero,
	@usuario,
	0,
	@email
)
update Users set idPersona = SCOPE_IDENTITY() where Users.usuario = @usuario
declare @tempIdPersona bigint;
set @tempIdPersona = SCOPE_IDENTITY();
insert into Cliente values (SCOPE_IDENTITY())

update Persona set idCliente = SCOPE_IDENTITY() where Persona.idPersona = @tempIdPersona
commit

------------------------------------------------------------------------------------------

create procedure registrarVendedor
@usuario varchar(50),
@tipoUser varchar(3),
@clave varchar(30),
@cedula varchar(11),
@nombre varchar(50),
@apellido varchar(50),
@provincia varchar(3),
@email varchar(62),
@numero varchar(10),
@tipoVendedor varchar(2)
as
begin tran
insert into Users
(
	usuario,
	idTipoUser,
	clave
)
values
(
	@usuario,
	convert(smallint, @tipoUser),
	@clave
)

insert into Persona
(
	cedula,
	nombre,
	apellido,
	idProvincia,
	numero,
	usuario,
	autorizado,
	email
)
values
(
	@cedula,
	@nombre,
	@apellido,
	convert(int, @provincia),
	@numero,
	@usuario,
	0,
	@email
)
update Users set idPersona = SCOPE_IDENTITY() where Users.usuario = @usuario
declare @tempIdPersona bigint;
set @tempIdPersona = SCOPE_IDENTITY();

insert into Vendedor
(
	idTipoVendedor,
	idPersona
)
values
(
	convert(smallint, @tipoVendedor),
	SCOPE_IDENTITY()
)


update Persona set idVendedor = SCOPE_IDENTITY() where Persona.idPersona = @tempIdPersona
commit

------------------------------------------------------------------------------------------

create function buscarClienteByCedula(@cedula varchar(11))
returns bigint
begin
	declare @ret bigint
	select @ret = c.idCliente
	from Cliente c
	where c.cedula = @cedula

	IF (@ret IS NULL)
        SET @ret = 0;
    RETURN @ret;
end

------------------------------------------------------------------------------------------
begin tran
rollback

select * from users
select * from persona
select * from cliente
select * from vendedor
select * from tipouser
select * from Provincias

begin tran
insert into Users values ('admin', 1, '123', null)
commit

exec registrarCliente @usuario = '%s', @tipoUser = '%s', @clave = '%s', @cedula = '%s', @nombre = '%s', @apellido = '%s', @provincia = '%s', @email = '%s', @numero = '%s'
@usuario varchar(50),
@tipoUser varchar(3),
@clave varchar(30),
@cedula varchar(11), 
@nombre varchar(50), 
@apellido varchar(50),
@provincia varchar(3), 
@email varchar(62),
@numero varchar(10)

exec registrarCliente @usuario = 'cliente', @tipoUser = 3, @clave = '123', @cedula = '1', @nombre = 'a',
@apellido = 'b', @provincia = 1, @email = 'b', @numero = '555'

begin tran
delete from users where usuario = 'cliente'
commit


begin tran
delete from Cliente where idCliente = 2
commit

select u.usuario, t.descripcion, u.clave from Users as u join TipoUser as t on u.idTipoUser = t.idTipoUser