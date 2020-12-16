
drop function if exists police.insert_in_tcl_case_name(varchar, varchar);
create or replace function police.insert_in_tcl_case_name
(in case_name_new varchar,
in severity_of_crime_new varchar,  
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.tcl_case_name
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param case_name_new: новое название преступления.
  * @param severity_of_crime_new: новая тяжесть преступления.
  * @return id вставленного кортежа.
  */
begin
	insert into police.tcl_case_name(case_name, severity_of_crime)
	values(case_name_new, severity_of_crime_new)
	returning id_case_name INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_tcl_case_name(integer, varchar, varchar);
create or replace function police.update_tcl_case_name
(in id_case_name_up integer, 
in case_name_new varchar,
in severity_of_crime_new varchar,
out id_case_name_old integer, 
out case_name_old varchar,
out severity_of_crime_old varchar)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.tcl_case_name
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_case_name_up: id изменяемого кортежа.
  * @param case_name_new: новое название преступления.
  * @param severity_of_crime_new: новая тяжесть преступления.
  * @return запись со значениями старого кортежа.
  */
begin
return query
	select id_case_name, case_name, severity_of_crime 
		from police.tcl_case_name 
		where id_case_name = id_case_name_up;
	update police.tcl_case_name
	set case_name = coalesce(case_name_new, case_name),
	severity_of_crime = coalesce(severity_of_crime_new, severity_of_crime)
	where id_case_name = id_case_name_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_tcl_case_name(integer);
create or replace function police.delete_from_tcl_case_name
(in id_case_name_del integer,
out id_case_name_old integer, 
out case_name_old varchar,
out severity_of_crime_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.tcl_case_name
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_case_name_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_case_name, case_name, severity_of_crime 
		from police.tcl_case_name  
		where id_case_name = id_case_name_del;
	delete from police.tcl_case_name
	where id_case_name = id_case_name_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_tcl_case_name('Расчленение', 'Супер мега пупер тяжкое');
-- select * from police.tcl_case_name;
-- select * from police.update_tcl_case_name(3, 'Расчленение и насилие', 'Супер мега пупер мега пупер тяжкое');
-- select * from police.tcl_case_name;
-- select * from police.delete_from_tcl_case_name(3);
-- select * from police.tcl_case_name;