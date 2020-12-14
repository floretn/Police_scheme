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
in name_role_new varchar)
returns record
as
$BODY$
/** Функция изменения значения в таблице police.tcl_role
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_role_up: id изменяемого кортежа, varchar: новое название роли.
  * @param name_role_new: новое название роли.
  * @return запись со значениями старого кортежа.
  */
declare
rec record;
begin
	select * from police.tcl_role into rec where id_role = id_role_up;
	update police.tcl_role
	set name_role = name_role_new
	where id_role = id_role_up;
	return rec;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_tcl_role(integer);
create or replace function police.delete_from_tcl_role
(in id_role_del integer)
returns record
as
$BODY$
/** Функция удаления значения из таблицы police.tcl_role
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param integer: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
declare
rec record;
begin
	select * from police.tcl_role into rec where id_role = id_role_del;
	delete from police.tcl_role
	where id_role = id_role_del;
	return rec;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_tcl_role('Левый поц');
-- select * from police.tcl_role;
-- select id_role, name_role from police.update_tcl_role(5, 'Правый поц')  as f(id_role integer, name_role varchar);
-- select * from police.tcl_role;
-- select id_role, name_role from police.delete_from_tcl_role(5)  as f(id_role integer, name_role varchar);
-- select * from police.tcl_role;