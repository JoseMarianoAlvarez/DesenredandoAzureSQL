SET LOCK_TIMEOUT -1;

-- 3 --
begin transaction
update t1
set
	valor = 'automovil'
where
	valor = 'auto'

select * from t1


-- 6 --
commit tran

select * from t1