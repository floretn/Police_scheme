
drop function if exists police.insert_in_tcl_contacts_type(varchar);
create or replace function police.insert_in_tcl_contacts_type
(in type_name_new varchar,  
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.tcl_contacts_type
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param type_name_new: новое название типа контактной информации.
  * @return id вставленного кортежа.
  */
begin
	insert into police.tcl_contacts_type(type_name)
	values(type_name_new)
	returning id_contacts_info INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_tcl_contacts_type(integer, varchar);
create or replace function police.update_tcl_contacts_type
(in id_contacts_info_up integer, 
in type_name_new varchar,
out id_contacts_info_old integer, 
out type_name_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.tcl_contacts_type
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_contacts_info_up: id изменяемого кортежа.
  * @param type_name_new: новое название типа контактной информации.
  * @return запись со значениями старого кортежа.
  */
begin
return query
	select id_contacts_info, type_name 
		from police.tcl_contacts_type 
		where id_contacts_info = id_contacts_info_up;
	update police.tcl_contacts_type
	set type_name = coalesce(type_name_new, type_name)
	where id_contacts_info = id_contacts_info_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_tcl_contacts_type(integer);
create or replace function police.delete_from_tcl_contacts_type
(in id_contacts_info_del integer,
out id_contacts_info_old integer, 
out type_name_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.tcl_contacts_type
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_contacts_info_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_contacts_info, type_name 
		from police.tcl_contacts_type 
		where id_contacts_info = id_contacts_info_del;
	delete from police.tcl_contacts_type
	where id_contacts_info = id_contacts_info_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_tcl_contacts_type('Левая инфа');
-- select * from police.tcl_contacts_type;
-- select * from police.update_tcl_contacts_type(3, 'Правая инфа');
-- select * from police.tcl_contacts_type;
-- select * from police.delete_from_tcl_contacts_type(3);
-- select * from police.tcl_contacts_type;