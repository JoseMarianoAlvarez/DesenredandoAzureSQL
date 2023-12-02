SET LOCK_TIMEOUT -1;

-- 1 --
create table t1
(
	id int not null primary key,
	valor varchar(100) not null
)
go

-- 2 --
insert into t1 
(
	id,
	valor
)
values
	(1,'auto'),
	(2,'avion'),
	(3,'camion'),
	(4,'moto'),
	(5 , 'barco')
go

select * from t1


-- 4 --

select * from t1 where valor = 'auto'
select * from t1 where valor = 'automovil'
select * from t1 



-- 5 --

begin transaction
update t1
set
	valor = 'automovil usado'
where
	valor = 'auto'


select * from t1 where valor = 'auto'
select * from t1 where valor = 'automovil'
select * from t1 


 -- 7 --
commit tran

select * from t1


-- 8 --
drop table t1
go

