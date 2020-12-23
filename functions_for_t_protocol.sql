
drop function if exists police.insert_in_t_protocol(integer, integer, boolean);
create or replace function police.insert_in_t_protocol
(in id_employee_new integer,
in id_case_name_new integer,
in status_new boolean,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_protocol
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_employee_new: id сотрудника, к которому относится протокол.
  * @param id_case_name: id названия преступления.
  * @param status_new: статус протокола (открыт/закрыт).
  * @return id вставленного кортежа.
  */
begin
	insert into police.t_protocol(id_employee, id_case_name, status)
	values(id_employee_new, id_case_name_new, status_new)
	returning id_protocol INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_protocol(integer, integer, integer, boolean);
create or replace function police.update_t_protocol
(in id_protocol_up integer, 
in id_employee_new integer,
in id_case_name_new integer,
in status_new boolean,
out id_protocol_old integer, 
out id_employee_old integer,
out id_case_name_old integer,
out status_old boolean)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_protocol
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_protocol_up: id изменяемого кортежа.
  * @param id_employee_new: id сотрудника, к которому относится протокол.
  * @param id_case_name: id названия преступления.
  * @param status_new: статус протокола (открыт/закрыт).
  * @return запись со значениями старого кортежа.
  */
begin	
return query
	select id_protocol, id_employee, id_case_name, status
		from police.t_protocol
		where id_protocol = id_protocol_up;
	update police.t_protocol
	set id_employee = coalesce(id_employee_new, id_employee), 
	id_case_name = coalesce(id_case_name_new, id_case_name),
	status = coalesce(status_new, status)
	where id_protocol = id_protocol_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_protocol(integer);
create or replace function police.delete_from_t_protocol
(in id_protocol_del integer,
out id_protocol_old integer, 
out id_employee_old integer,
out id_case_name_old integer,
out status_old boolean)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_protocol
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_protocol_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_protocol, id_employee, id_case_name, status
		from police.t_protocol
		where id_protocol = id_protocol_del;
	delete from police.t_protocol
	where id_protocol = id_protocol_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_protocol(1, 2, false);
-- select * from police.t_protocol;
-- select * from police.update_t_protocol(3, 2, 1, true);
-- select * from police.t_protocol;
-- select * from police.delete_from_t_protocol(3);
-- select * from police.t_protocol;
