
drop function if exists police.insert_in_t_person(varchar, varchar, varchar);
create or replace function police.insert_in_t_person
(in last_name_new varchar,
in first_name_new varchar,
in patronymic_new varchar,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_person
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param last_name_new: фамилия нового человека.
  * @param first_name_new: имя нового человека.
  * @param patronymic_new: отчество нового человека (при наличии).
  * @return id вставленного кортежа.
  */
begin
	insert into police.t_person(last_name, first_name, patronymic)
	values(last_name_new, first_name_new, patronymic_new)
	returning id_person INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_person(integer, varchar, varchar, varchar);
create or replace function police.update_t_person
(in id_person_up integer, 
in last_name_new varchar,
in first_name_new varchar,
in patronymic_new varchar,
out id_person_old integer, 
out last_name_old varchar,
out first_name_old varchar,
out patronymic_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_person
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_person_up: id изменяемого кортежа.
  * @param last_name_new: фамилия нового человека.
  * @param first_name_new: имя нового человека.
  * @param patronymic_new: отчество нового человека (при наличии).
  * @return запись со значениями старого кортежа.
  */
begin	
return query
	select id_person, last_name, first_name, patronymic
		from police.t_person
		where id_person = id_person_up;
	update police.t_person
	set last_name = coalesce(last_name_new, last_name),
	first_name = coalesce(first_name_new, first_name),
	patronymic = coalesce(patronymic_new, patronymic)
	where id_person = id_person_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_person(integer);
create or replace function police.delete_from_t_person
(in id_person_del integer,
out id_person_old integer, 
out last_name_old varchar,
out first_name_old varchar,
out patronymic_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_person
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_person_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_person, last_name, first_name, patronymic
		from police.t_person
		where id_person = id_person_del;
	delete from police.t_person
	where id_person = id_person_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_person('ЛеваяФамилия', 'ЛевоеИмя', 'ЛевоеОтчество');
-- select * from police.t_person;
-- select * from police.update_t_person(6, null, null, 'ПравоеОтчество');
-- select * from police.t_person;
-- select * from police.delete_from_t_person(6);
-- select * from police.t_person;
