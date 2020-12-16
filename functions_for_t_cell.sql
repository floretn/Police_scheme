
drop function if exists police.insert_in_t_cell(integer, integer);
create or replace function police.insert_in_t_cell
(in number_of_places_new integer,
in employed_places_new integer,  
out id_new integer)
as
$BODY$
/** Функция добавления значения в таблицу police.t_cell
  * @author Софронов И.Е.
  * @version 15.12.20
  * @param number_of_places_new: количество мест новой камеры.
  * @param employed_places_new: количество занятых мест.
  * @throw ошибка соответствия реальности, если один из параметров меньше нуля.
  * @throw ошибка соответствия реальности, если number_of_places_new меньше employed_places_new.
  * @return id вставленного кортежа.
  */
begin
	if employed_places_new > number_of_places_new
	then 
	    raise exception 'Ошибка соответствия реальности! Количество занятых мест не может превышать общее число мест!';
	end if;

	if employed_places_new < 0 or number_of_places_new <= 0
	then 
	    raise exception 'Ошибка соответствия реальности! Количество общих мест не может быть нулём и менее или количество занятых мест не может быть меньше нуля!';
	end if;
	insert into police.t_cell(number_of_places, employed_places)
	values(number_of_places_new, employed_places_new)
	returning id_cell INTO id_new;
	return;
end;
$BODY$
language plpgsql;

drop function if exists police.update_t_cell(integer, integer, integer);
create or replace function police.update_t_cell
(in id_cell_up integer, 
in number_of_places_new integer,
in employed_places_new integer,
out id_cell_old integer,
out number_of_places_old integer,
out employed_places_old integer)
returns setof record
as
$BODY$
/** Функция изменения значения в таблице police.t_cell
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_number_of_places_up: id изменяемого кортежа.
  * @param number_of_places_new: количество мест новой камеры.
  * @param employed_places_new: количество занятых мест.
  * @throw ошибка соответствия реальности, если один из параметров меньше нуля.
  * @throw ошибка соответствия реальности, если number_of_places_new меньше employed_places_new.
  * @return запись со значениями старого кортежа.
  */
begin
	if employed_places_new > number_of_places_new
	then 
	    raise exception 'Ошибка соответствия реальности! Количество занятых мест не может превышать общее число мест!';
	end if;

	if employed_places_new < 0 or number_of_places_new <= 0
	then 
	    raise exception 'Ошибка соответствия реальности! Количество общих мест не может быть нулём и менее или количество занятых мест не может быть меньше нуля!';
	end if;
	
return query
	select id_cell, number_of_places, employed_places 
		from police.t_cell 
		where id_cell = id_cell_up;
	update police.t_cell
	set number_of_places = coalesce(number_of_places_new, number_of_places),
	employed_places = coalesce(employed_places_new, employed_places)
	where id_cell = id_cell_up;
end;
$BODY$
language plpgsql;

drop function if exists police.delete_from_t_cell(integer);
create or replace function police.delete_from_t_cell
(in id_cell_del integer,
out od_cell_old integer,
out number_of_places_old integer,
out employed_places_old integer)
returns setof record
as
$BODY$
/** Функция удаления значения из таблицы police.t_cell
  * @author Софронов И.Е.
  * @version 01.12.20
  * @param id_cell_del: id удаляемогоо кортежа.
  * @return запись со значениями удалённого кортежа.
  */
begin
return query
	select id_cell, number_of_places, employed_places 
		from police.t_cell 
		where id_cell= id_cell_del;
	delete from police.t_cell
	where id_cell = id_cell_del;
end;
$BODY$
language plpgsql;

-- Проверка работы функций: 
-- select * from police.insert_in_t_cell(5, 0);
-- select * from police.t_cell;
-- select * from police.update_t_cell(2, 6, 2);
-- select * from police.t_cell;
-- select * from police.delete_from_t_cell(2);
-- select * from police.t_cell;
-- select * from police.insert_in_t_cell(0, 0);
-- select * from police.insert_in_t_cell(2, -3);
-- select * from police.update_t_cell(1, 0, 2);
