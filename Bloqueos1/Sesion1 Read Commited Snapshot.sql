select * 
from sys.configurations order by name

drop table t1
go

-- 1 --
create table t1
(
id int not null identity(1,1) primary key,
valor varchar(100) not null
)
go

-- 3 --
select * from t1


-- 5 --
select * from t1

-- 6 --
insert into t1 
(
	valor
)
values
	('moto')

select * from t1

-- 8 --
begin transaction 
insert into t1 
(
	valor
)
values
	('barco')

select * from t1

 -- 10 --
commit tran

select * from t1

-- 13 --
select * from t1

