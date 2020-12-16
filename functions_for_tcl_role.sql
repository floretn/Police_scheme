
drop function if exists police.insert_in_tcl_role(varchar);
create or replace function police.insert_in_tcl_role
(in name_role_new varchar,  
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.tcl_role
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param name_role_new: новое название роли.
  * @return id вставленного кортежа.
  */
begin
	insert into police.tcl_role(name_role)
	values(name_role_new)
	returning id_role INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_tcl_role(integer, varchar);
create or replace function police.update_tcl_role
(in id_role_up integer, 
in name_role_new varchar,
out id_role_old integer, 
out name_role_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.tcl_role
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_role_up: id изменяемого кортежа.
  * @param name_role_new: новое название роли.
  * @return запись со значениями старого кортежа.
  */
begin
return query
	select id_role, name_role 
		from police.tcl_role 
		where id_role = id_role_up;
	update police.tcl_role
	set name_role = coalesce(name_role_new, name_role)
	where id_role = id_role_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_tcl_role(integer);
create or replace function police.delete_from_tcl_role
(in id_role_del integer,
out id_role_old integer, 
out name_role_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.tcl_role
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_role_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_role, name_role 
		from police.tcl_role
		where id_role = id_role_del;
	delete from police.tcl_role
	where id_role = id_role_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_tcl_role('Левый поц');
-- select * from police.tcl_role;
-- select * from police.update_tcl_role(5, 'Правый поц');
-- select * from police.tcl_role;
-- select * from police.delete_from_tcl_role(5);
-- select * from police.tcl_role;