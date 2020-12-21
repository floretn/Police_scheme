
drop function if exists police.insert_in_t_person_contacts(integer, integer, varchar);
create or replace function police.insert_in_t_person_contacts
(in id_person_new integer,
in id_contacts_info_new integer,
in value_contacts_info_new varchar,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_person_contacts
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_person_new: id служащего.
  * @param id_contacts_info_new: id типа контактной информации.
  * @param value_contscts_info_new: новая контактная информация.
  * @return id вставленного кортежа.
  */
begin
	insert into police.t_person_contacts(id_person, id_contacts_info, value_contacts_info)
	values(id_person_new, id_contacts_info_new, value_contacts_info_new)
	returning id_person_contacts INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_person_contacts(integer, integer, integer, varchar);
create or replace function police.update_t_person_contacts
(in id_person_contacts_up integer, 
in id_person_new integer,
in id_contacts_info_new integer,
in value_contacts_info_new varchar,
out id_person_contacts_old integer, 
out id_person_old integer,
out d_contacts_info_old integer,
out value_contacts_info_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_person_contacts
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_person_contacts_up: id изменяемого кортежа.
  * @param id_person_new: id служащего.
  * @param id_contacts_info_new: id типа контактной информации.
  * @param value_contscts_info_new: новая контактная информация.
  * @return запись со значениями старого кортежа.
  */
begin	
return query
	select id_person_contacts, id_person, id_contacts_info, value_contacts_info
		from police.t_person_contacts
		where id_person_contacts = id_person_contacts_up;
	update police.t_person_contacts
	set id_person = coalesce(id_person_new, id_person), 
	id_contacts_info = coalesce(id_contacts_info_new, id_contacts_info),
	value_contacts_info = coalesce(value_contacts_info_new, value_contacts_info)
	where id_person_contacts = id_person_contacts_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_person_contacts(integer);
create or replace function police.delete_from_t_person_contacts
(in id_person_contacts_del integer,
out id_person_contacts_old integer, 
out id_person_old integer,
out d_contacts_info_old integer,
out value_contacts_info_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_person_contacts
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_person_contacts_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_person_contacts, id_person, id_contacts_info, value_contacts_info
		from police.t_person_contacts
		where id_person_contacts = id_person_contacts_del;
	delete from police.t_person_contacts
	where id_person_contacts = id_person_contacts_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_person_contacts(1, 2, 'Номерок блатной, три семёрочки');
-- select * from police.t_person_contacts;
-- select * from police.update_t_person_contacts(7, 2, null, 'Номер 666');
-- select * from police.t_person_contacts;
-- select * from police.delete_from_t_person_contacts(7);
-- select * from police.t_person_contacts;
