
drop function if exists police.insert_in_t_investigation_participants(integer, integer, integer, integer);
create or replace function police.insert_in_t_investigation_participants
(in id_role_new integer,
in id_protocol_new integer,
in id_person_new integer,
in id_cell_new integer default null,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_investigation_participants
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_role_new: id роли участника следствия в деле.
  * @param id_protocol_new: id протокола, к которому относится участник следствия.
  * @param id_person_new: id человека, который является участником следствия.
  * @param id_cell_new: id камеры. Не null только в том случае, если роль участника - подсудимый.
  * @return id вставленного кортежа.
  * @throw ошибка при значении id_cell не равного null, если роль человека не равна 4 (подсудимый).
  */
declare
need_for_cell integer;
my_record record;
my_id_cell integer;
my_id_cell2 integer;
begin
	if not (id_cell_new is null) and id_role_new != 4
	then
		raise exception 'Нельзя сажать в камеру людей, вина которых недоказана! 
		Презумпция невиновности, ничем не можем вам помочь...';
	end if;
	insert into police.t_investigation_participants(id_role, id_protocol, id_person, id_cell)
	values(id_role_new, id_protocol_new, id_person_new, id_cell_new)
	returning id_participants INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_investigation_participants(integer, integer, integer, integer, integer);
create or replace function police.update_t_investigation_participants
(in id_participants_up integer, 
in id_role_new integer,
in id_protocol_new integer,
in id_person_new integer,
in id_cell_new integer default null,
out id_participants_old integer, 
out id_role_old integer, 
out id_protocol_old integer,
out id_person_old integer,
out id_cell_old integer)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_investigation_participants
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_participants_up: id изменяемого кортежа.
  * @param id_role_new: id роли участника следствия в деле.
  * @param id_protocol_new: id протокола, к которому относится участник следствия.
  * @param id_person_new: id человека, который является участником следствия.
  * @param id_cell_new: id камеры. Не null только в том случае, если роль участника - подсудимый.
  * @return запись со значениями старого кортежа.
  * @throw ошибка при значении id_cell не равного null, если роль человека не равна 4 (подсудимый).
  */
declare
rec record;
begin	
return query
	select id_participants, id_role, id_protocol, id_person, id_cell
		from police.t_investigation_participants
		where id_participants = id_participants_up;

	select id_participants, id_role, id_protocol, id_person, id_cell
		from police.t_investigation_participants
		where id_participants = id_participants_up
		into rec;
		
	if not (id_cell_new is null) and coalesce(id_role_new, rec.id_role) != 4
	then
		raise exception 'Нельзя сажать в камеру людей, вина которых недоказана! 
		Презумпция невиновности, ничем не можем вам помочь...';
	end if;

	update police.t_investigation_participants 
		set id_role = coalesce(id_role_new, id_role),
		id_protocol = coalesce(id_protocol_new, id_protocol),
		id_person = coalesce(id_person_new, id_person),
		id_cell = id_cell_new
		where id_participants = id_participants_up;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_investigation_participants(integer);
create or replace function police.delete_from_t_investigation_participants
(in id_participants_del integer,
out id_participants_old integer, 
out id_role_old integer, 
out id_protocol_old integer,
out id_person_old integer,
out id_cell_old integer)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_investigation_participants
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_protocol_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_participants, id_role, id_protocol, id_person, id_cell
		from police.t_investigation_participants
		where id_participants = id_participants_del;
	delete from police.t_investigation_participants
	where id_participants = id_participants_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_investigation_participants(4, 1, 3, 1);
-- select * from police.t_investigation_participants;
-- select * from police.update_t_investigation_participants(14, 4, 2, 3, 3);
-- select * from police.t_investigation_participants;
-- select * from police.delete_from_t_investigation_participants(6);
-- select * from police.t_investigation_participants;
