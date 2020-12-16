
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
in function_new varchar,
out id_post_old integer, 
out id_parent_post_old integer,
out function_old varchar)
returns setof record
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
begin
return query
	select id_post, id_parent_post, function 
		from police.tcl_post 
		where id_post = id_post_up;
	update police.tcl_post
	set id_parent_post = coalesce(id_parent_post_new, id_parent_post),
	function = coalesce(function_new, function) 
	where id_post = id_post_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_tcl_post(integer);
create or replace function police.delete_from_tcl_post
(in id_post_del integer,
out id_post_old integer, 
out id_parent_post_old integer,
out function_old varchar)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.tcl_post
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_post_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_post, id_parent_post, function 
		from police.tcl_post
		where id_post = id_post_del;
	delete from police.tcl_post
	where id_post = id_post_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_tcl_post(1, 'Левый поц');
-- select * from police.tcl_post;
-- select * from police.update_tcl_post(3, 3, 'Правый поц');
-- select * from police.tcl_post;
-- select * from police.delete_from_tcl_post(4);
-- select * from police.tcl_post;