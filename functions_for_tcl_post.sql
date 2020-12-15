
drop function if exists police.insert_in_tcl_post(integer, varchar);
create or replace function police.insert_in_tcl_post
(in id_parent_post_new integer,
in function_new varchar,  
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.tcl_post
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param id_parent_post_new: новый id поста начальника.
  * @param function_new: новая исполняемая функция поста.
  * @return id вставленного кортежа.
  */
begin
	insert into police.tcl_post(id_parent_post, function)
	values(id_parent_post_new, function_new)
	returning id_post INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_tcl_post(integer, integer, varchar);
create or replace function police.update_tcl_post
(in id_post_up integer, 
in id_parent_post_new integer,
in function_new varchar)
returns record
as
$BODY$
/** Функция изменения значения в таблице police.tcl_post
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_post_up: id изменяемого кортежа.
  * @param id_parent_post_new: новый id поста начальника.
  * @param function_new: новая исполняемая функция поста.
  * @return запись со значениями старого кортежа.
  */
declare
rec record;
begin
	select id_post, id_parent_post, function from police.tcl_post into rec where id_post = id_post_up;
	update police.tcl_post
	set id_parent_post = id_parent_post_new,
	function = function_new 
	where id_post = id_post_up;
	return rec;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_tcl_post(integer);
create or replace function police.delete_from_tcl_post
(in id_post_del integer)
returns record
as
$BODY$
/** Функция удаления значения из таблицы police.tcl_post
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_post_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
declare
rec record;
begin
	select id_post, id_parent_post, function from police.tcl_post into rec where id_post = id_post_del;
	delete from police.tcl_post
	where id_post = id_post_del;
	return rec;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_tcl_post(1, 'Левый поц');
-- select * from police.tcl_post;
-- select id_post, id_parent_post, function from police.update_tcl_post(4, 3, 'Правый поц') as f(id_post integer, id_parent_post integer, function varchar);
-- select * from police.tcl_post;
-- select id_post, id_parent_post, function from police.delete_from_tcl_post(4) as f(id_post integer, id_parent_post integer, function varchar);
-- select * from police.tcl_post;