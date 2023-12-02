-- TSQL
-- Creo una tabla con los siguientes campos:
-- Id, Nombre, Apellido, Edad,  FechaNacimiento, FechaCreacion, FechaModificacion

set nocount ON
go

create table Persona
(
    Id int identity(1,1) primary key,
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    Edad int not null,
    FechaNacimiento date not null 
)
GO

set nocount ON
-- inserto 5000 personas con datos aleatorios
declare @i int = 0
while @i < 5000
begin
    insert into Persona (Nombre, Apellido, Edad, FechaNacimiento)
    values (newid(), newid(), abs(checksum(newid())) % 100, dateadd(day, abs(checksum(newid())) % 10000, '2000-01-01'))
    set @i = @i + 1
end
GO

Select count(*) from Persona

select top 10 * from Persona

declare @apellido nvarchar(50) = '207EA23D-CCB2-425A-B729-7B386CDDE883'
select * from persona where Apellido = @apellido 

--creo el indice por apellido
create index idx_apellido on Persona (Apellido)
GO


declare @apellido nvarchar(50) = '207EA23D-CCB2-425A-B729-7B386CDDE883'
select * from persona where Apellido = @apellido 



declare @apellido1 nvarchar(50) = '207EA23D-CCB2-425A-B729-7B386CDDE883'
declare @apellido2 varchar(50) = '207EA23D-CCB2-425A-B729-7B386CDDE883'

select * from persona where Apellido = @apellido1
select * from persona where Apellido = @apellido2
