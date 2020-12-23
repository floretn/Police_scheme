
drop function if exists police.insert_in_t_evidence(integer, varchar, integer);
create or replace function police.insert_in_t_evidence
(in id_protocol_new integer,
in object_description_new varchar,
in storage_box_new integer,
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_evidence
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_protocol_new: id протокола, к которому относится улика.
  * @param object_description_new: описание улики.
  * @param storage_box_new: номер ячейки хранения улики.
  * @return id вставленного кортежа.
  * @throw ошибка добавления в одну ячейку улик разных протоколов.
  */
 declare
 protocol integer;
begin
	select id_protocol from police.t_evidence
		where storage_box = storage_box_new
		into protocol;
	if not (protocol is null) and protocol != id_protocol_new
	then
		raise exception 'В одну ячейку можно класть улики только для одного протокола!';
	end if;
	insert into police.t_evidence(id_protocol, object_description, storage_box)
	values(id_protocol_new, object_description_new, storage_box_new)
	returning id_evidence INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_evidence(integer, integer, varchar, integer);
create or replace function police.update_t_evidence
(in id_evidence_up integer, 
in id_protocol_new integer,
in object_description_new varchar,
in storage_box_new integer,
out id_evidence_old integer, 
out id_protocol_old integer,
out object_description_old varchar,
out storage_box_old integer)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_evidence
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_evidence_up: id изменяемого кортежа.
  * @param id_protocol_new: id протокола, к которому относится улика.
  * @param object_description_new: описание улики.
  * @param storage_box_new: номер ячейки хранения улики.
  * @return запись со значениями старого кортежа.
  * @throw ошибка добавления в одну ячейку улик разных протоколов.
  */
  declare
 protocol integer;
begin	
return query
	select id_evidence, id_protocol, object_description, storage_box
		from police.t_evidence
		where id_evidence = id_evidence_up;
	select id_protocol from police.t_evidence
		where storage_box = storage_box_new
		into protocol;
	if not (protocol is null) and protocol != id_protocol_new
	then
		raise exception 'В одну ячейку можно класть улики только для одного протокола!';
	end if;
	update police.t_evidence
	set id_protocol = coalesce(id_protocol_new, id_protocol), 
	object_description = coalesce(object_description_new, object_description),
	storage_box = coalesce(storage_box_new, storage_box)
	where id_evidence = id_evidence_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_evidence(integer);
create or replace function police.delete_from_t_evidence
(in id_evidence_del integer,
out id_evidence_old integer, 
out id_protocol_old integer,
out object_description_old varchar,
out storage_box_old integer)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_evidence
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_evidence_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_evidence, id_protocol, object_description, storage_box
		from police.t_evidence
		where id_evidence = id_evidence_del;
	delete from police.t_evidence
	where id_evidence = id_evidence_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_evidence(1, 'Бензопила', 1);
-- select * from police.t_evidence;
-- select * from police.insert_in_t_evidence(2, 'Бензопила', 1);
-- select * from police.update_t_evidence(4, 2, null, 4);
-- select * from police.update_t_evidence(4, 2, null, 1);
-- select * from police.t_evidence;
-- select * from police.delete_from_t_evidence(4);
-- select * from police.t_evidence;
