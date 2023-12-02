select * 
from sys.configurations order by name


-- 1 --
create table t1
(
	id int not null primary key,
	valor varchar(100) not null
)
go

-- 3 --
select * from t1


-- 5 --
select * from t1  -- El camion id=3 no aparece porque aun noe stá confirmado

-- Entonces estaria insertando el numero que sigue que es el 3 segun la vista de esta session

-- 6 -- Parte A
insert into t1 
(
	id,
	valor
)
values
	(3,'moto')   --- Estoy usando el mismo numero que la otra sesion

-- 6 -- Parte B --- Revisar el reporte de bloqueos luego cancelar

-- 6 -- Parte C Lock Timeout

SET LOCK_TIMEOUT 3000;
insert into t1 
(
	id,
	valor
)
values
	(3,'moto');

select @@error

-- 6 -- Parte D Cancelo y pruebo con id=4 en lugar de 3




insert into t1 
(
	id,
	valor
)
values
	(4,'moto')   --- Estoy usando un numero que no está en la otra sesion



select * from t1



-- 8 --
begin transaction 
insert into t1 
(
	id,
	valor
)
values
	(5 , 'barco')

select * from t1

 -- 10 --
commit tran

select * from t1

-- 13 --
select * from t1


-- 14 --
drop table t1
go