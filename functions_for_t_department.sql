
drop function if exists police.insert_in_t_department(varchar);
create or replace function police.insert_in_t_department
(in department_name_new varchar,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_department
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param department_name_new: новое имя департамента.
  * @return id вставленного кортежа.
  */
begin
	insert into police.t_department(department_name)
	values(department_name_new)
	returning id_department INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_department(integer, varchar);
create or replace function police.update_t_department
(in id_department_up integer, 
in department_name_new varchar,
out id_department_old integer, 
out department_name_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_department
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_department_name_up: id изменяемого кортежа.
  * @param department_name_new: новое имя департамента.
  * @return запись со значениями старого кортежа.
  */
begin	
return query
	select id_department, department_name
		from police.t_department 
		where id_department = id_department_up;
	update police.t_department
	set department_name = coalesce(department_name_new, department_name)
	where id_department = id_department_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_department(integer);
create or replace function police.delete_from_t_department
(in id_department_del integer,
out id_department_old integer, 
out department_name_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_department
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_department_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_department, department_name
		from police.t_department 
		where id_department= id_department_del;
	delete from police.t_department
	where id_department = id_department_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_department('Левый департамент');
-- select * from police.t_department;
-- select * from police.update_t_department(3, 'Правый департамент');
-- select * from police.t_department;
-- select * from police.delete_from_t_department(3);
-- select * from police.t_department;
