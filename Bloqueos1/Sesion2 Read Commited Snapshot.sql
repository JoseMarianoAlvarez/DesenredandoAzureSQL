-- 2 --

insert into t1 
(
	valor
)
values
	('auto'),
	('avion')
go

-- 4 --
begin transaction 
insert into t1 
(
	valor
)
values
	('camion')

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