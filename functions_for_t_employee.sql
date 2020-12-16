
drop function if exists police.insert_in_t_employee(integer, integer, varchar, varchar, varchar, varchar);
create or replace function police.insert_in_t_employee
(in id_post_new integer,
in id_department_new integer,
in last_name_new varchar,
in first_name_new varchar,
in patronymic_new varchar,
in rank_new varchar,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_employee
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_post_new: id нового занимаемого поста.
  * @param id_department_new: id департамента нового служащего.
  * @param last_name_new: фамилия нового служащего.
  * @param first_name_new: имя нового служащего.
  * @param patronymic_new: отчество нового служащего (при наличии).
  * @param post_new: звание нового служащего.
  * @return id вставленного кортежа.
  */
begin
	insert into police.t_employee(id_post, id_department, last_name, first_name, patronymic, rank)
	values(id_post_new, id_department_new, last_name_new, first_name_new, patronymic_new, rank_new)
	returning id_employee INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_employee(integer, integer, integer, varchar, varchar, varchar, varchar);
create or replace function police.update_t_employee
(in id_employee_up integer, 
in id_post_new integer,
in id_department_new integer,
in last_name_new varchar,
in first_name_new varchar,
in patronymic_new varchar,
in rank_new varchar,
out id_employee_old integer, 
out id_post_old integer,
out id_department_old integer,
out last_name_old varchar,
out first_name_old varchar,
out patronymic_old varchar,
out rank_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_employee
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_employee_up: id изменяемого кортежа.
  * @param id_post_new: id нового занимаемого поста.
  * @param id_department_new: id департамента нового служащего.
  * @param last_name_new: фамилия нового служащего.
  * @param first_name_new: имя нового служащего.
  * @param patronymic_new: отчество нового служащего (при наличии).
  * @param rank_new: звание нового служащего.
  * @return запись со значениями старого кортежа.
  */
begin	
return query
	select id_employee, id_post, id_department, last_name, first_name, patronymic, rank
		from police.t_employee
		where id_employee = id_employee_up;
	update police.t_employee
	set id_post = coalesce(id_post_new, id_post), 
	id_department = coalesce(id_department_new, id_department),
	last_name = coalesce(last_name_new, last_name),
	first_name = coalesce(first_name_new, first_name),
	patronymic = coalesce(patronymic_new, patronymic),
	rank = coalesce(rank_new, rank)
	where id_employee = id_employee_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_employee(integer);
create or replace function police.delete_from_t_employee
(in id_employee_del integer,
out id_employee_old integer, 
out id_post_old integer,
out id_department_old integer,
out last_name_old varchar,
out first_name_old varchar,
out patronymic_old varchar,
out rank_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_employee
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_employee_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_employee, id_post, id_department, last_name, first_name, patronymic, rank
		from police.t_employee
		where id_employee = id_employee_del;
	delete from police.t_employee
	where id_employee = id_employee_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_employee(1, 1, 'ЛеваяФамилия', 'ЛевоеИмя', 'ЛевоеОтчество', 'ЛевыоеЗвание');
-- select * from police.t_employee;
-- select * from police.update_t_employee(4, null, null, null, null, 'ПравоеОтчество', 'ПравоеЗвание');
-- select * from police.t_employee;
-- select * from police.delete_from_t_employee(4);
-- select * from police.t_employee;
