-- 2 --

insert into t1 
(
	id,
	valor
)
values
	(1,'auto'),
	(2,'avion')
go

-- 4 --
begin transaction 
insert into t1 
(
	id,
	valor
)
values
	(3,'camion')

select * from t1


-- 7 --
select * from t1

-- 9 
select * from t1

-- 11 -- 
select * from t1

-- 12 --
commit tran

select * from t1