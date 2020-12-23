drop table if exists police.t_logger;
create table police.t_logger
(
id_log serial,
user_name varchar,
command_name varchar,
time_of_action time,
record_was_iud varchar,
PRIMARY KEY (id_log) 
);


drop function if exists police.f_for_tg_t_evidence_logger() cascade;

create or replace function police.f_for_tg_t_evidence_logger()
returns trigger as
$BODY$
/**
* Функция логирования операций, производимых с таблицей t_evidence. 
*@version 23.12.20
*/
declare
rec record;
 begin
	if tg_op = 'INSERT'
	then
		insert into police.t_logger (user_name, command_name, time_of_action, record_was_iud)
		values (current_user, tg_op, localtime, new);
		rec = new;
	else if tg_op = 'UPDATE' or tg_op = 'DELETE'
	then 
		insert into police.t_logger (user_name, command_name, time_of_action, record_was_iud)
		values (current_user, tg_op, localtime, old);
		rec = old;
	end if;
	end if;
	return rec;
end;
$BODY$
language plpgsql;


create trigger tg_t_evidence_logger
before
insert or update or delete on police.t_evidence
for each row
execute procedure police.f_for_tg_t_evidence_logger();

-- Проверка работы триггера (Можно поменять пользователя на sherlock_holms, например. Но ему доступна только вставка.): 
-- select * from police.insert_in_t_evidence(2, 'Бензопила', 2);
-- select * from police.t_evidence;
-- select * from police.update_t_evidence(4, 2, 'Бензопила в крови', 2);
-- select * from police.t_evidence;
-- select * from police.delete_from_t_evidence(4);
-- select * from police.t_evidence;
