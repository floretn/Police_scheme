begin;

drop schema if exists "police" cascade;
create schema "police";

CREATE TABLE police.tcl_role
( 
	id_role			serial,
	name_role		character varying(50) not null,
	PRIMARY KEY (id_role) 
	--on delete cascade on update cascade
);

CREATE TABLE police.t_cell
( 
	id_cell			serial,
	number_of_places	integer not null,
	employed_places		integer not null,
	PRIMARY KEY (id_cell) 
	--on delete cascade on update cascade
);

CREATE TABLE police.t_person
( 
	id_person		serial,
	last_name		character varying(50) not null,
	first_name		character varying(50) not null,
	patronymic		character varying(50),
	PRIMARY KEY (id_person)
	--on delete cascade on update cascade 
);

CREATE TABLE police.tcl_case_name
( 
	id_case_name		serial,
	case_name		character varying(50) not null,
	severity_of_crime	character varying(50) not null,
	PRIMARY KEY (id_case_name) 
	--on delete cascade on update cascade
);

CREATE TABLE police.tcl_contacts_type
( 
	id_contacts_info	serial,
	type_name		character varying(50) not null,
	PRIMARY KEY (id_contacts_info) 
	--on delete cascade on update cascade
);

CREATE TABLE police.t_department
( 
	id_department		serial,
	department_name		character varying(50) not null,
	PRIMARY KEY (id_department) 
	--on delete cascade on update cascade
);

CREATE TABLE police.tcl_post
( 
	id_post			serial,
	id_parent_post		integer not null,
	function		character varying(50) not null,
	PRIMARY KEY (id_post),
	FOREIGN KEY (id_parent_post) REFERENCES police.tcl_post (id_post)
	--on delete cascade on update cascade
);

CREATE TABLE police.t_person_contacts
( 
	id_person_contacts	serial,
	id_person		integer not null,
	id_contacts_info	integer not null,
	value_contacts_info	character varying(50) not null,
	PRIMARY KEY (id_person_contacts),
	FOREIGN KEY (id_person) REFERENCES police.t_person (id_person),
	FOREIGN KEY (id_contacts_info) REFERENCES police.tcl_contacts_type (id_contacts_info)
	--on delete cascade on update cascade
);


CREATE TABLE police.t_employee
( 
	id_employee		serial,
	id_post			integer not null,
	id_department		integer not null,
	last_name		character varying(50) not null,
	first_name		character varying(50) not null,
	patronymic		character varying(50),
	rank			character varying(50) not null,
	PRIMARY KEY (id_employee),
	FOREIGN KEY (id_post) REFERENCES police.tcl_post (id_post),
	FOREIGN KEY (id_department) REFERENCES police.t_department (id_department)
	--on delete cascade on update cascade
);

CREATE TABLE police.t_employee_contacts
( 
	id_employee_contacts	serial,
	id_employee		integer not null,
	id_contacts_info	integer not null,
	value_contacts_info	character varying(50) not null,
	PRIMARY KEY (id_employee_contacts),
	FOREIGN KEY (id_employee) REFERENCES police.t_employee (id_employee),
	FOREIGN KEY (id_contacts_info) REFERENCES police.tcl_contacts_type (id_contacts_info)
	--on delete cascade on update cascade
);

CREATE TABLE police.t_protocol
( 
	id_protocol		serial,
	id_employee		integer not null,
	id_case_name		integer not null,
	status			boolean not null,
	PRIMARY KEY (id_protocol),
	FOREIGN KEY (id_employee) REFERENCES police.t_employee (id_employee),
	FOREIGN KEY (id_case_name) REFERENCES police.tcl_case_name (id_case_name)
	--on delete cascade on update cascade
);

CREATE TABLE police.t_evidence
( 
	id_evidence		serial,
	id_protocol		integer not null,
	object_description	character varying(100) not null,
	storage_box		integer,
	PRIMARY KEY (id_evidence),
	FOREIGN KEY (id_protocol) REFERENCES police.t_protocol (id_protocol)
	--on delete cascade on update cascade
);

CREATE TABLE police.t_investigation_participants
( 
	id_participants		serial,
	id_role			integer not null,
	id_protocol		integer not null,
	id_person		integer not null,
	id_cell			integer,
	PRIMARY KEY (id_participants),
	FOREIGN KEY (id_role) REFERENCES police.tcl_role (id_role),
	FOREIGN KEY (id_protocol) REFERENCES police.t_protocol (id_protocol),
	FOREIGN KEY (id_person) REFERENCES police.t_person (id_person),
	FOREIGN KEY (id_cell) REFERENCES police.t_cell (id_cell)
	--on delete cascade on update cascade
);

------------------------------------------------------------------------------------------

INSERT INTO police.tcl_role (name_role) VALUES ('Подозреваемый');
INSERT INTO police.tcl_role (name_role) VALUES ('Свидетель');
INSERT INTO police.tcl_role (name_role) VALUES ('Потерпевший');
INSERT INTO police.tcl_role (name_role) VALUES ('Подсудимый');



INSERT INTO police.t_cell (number_of_places, employed_places) VALUES (5, 4);


INSERT INTO police.t_person (last_name, first_name, patronymic) VALUES ('Раскольников', 'Родион', 'Романович');
INSERT INTO police.t_person (last_name, first_name, patronymic) VALUES ('Процентщица', 'Алёна', 'Ивановна');
INSERT INTO police.t_person (last_name, first_name, patronymic) VALUES ('Свидригайлов', 'Аркадий', 'Иванович');
INSERT INTO police.t_person (last_name, first_name, patronymic) VALUES ('Сестра', 'Лизавета', 'Ивановна');
INSERT INTO police.t_person (last_name, first_name) VALUES ('Мориарти', 'Джеймс');



INSERT INTO police.tcl_case_name (case_name, severity_of_crime) VALUES ('Двойное убийство', 'Очень Тяжкое');
INSERT INTO police.tcl_case_name (case_name, severity_of_crime) VALUES ('Наполеон преступного мира', 'Загадочное');



INSERT INTO police.tcl_contacts_type (type_name) VALUES ('Адрес');
INSERT INTO police.tcl_contacts_type (type_name) VALUES ('Телефон');



INSERT INTO police.t_department (department_name) VALUES ('3-й полицейский участок Казанской части');
INSERT INTO police.t_department (department_name) VALUES ('Скотлен-ярд');



INSERT INTO police.tcl_post(id_parent_post,function) VALUES (1, 'Начальник отдела');
INSERT INTO police.tcl_post(id_parent_post,function) VALUES (1, 'Следователь');
INSERT INTO police.tcl_post(id_parent_post,function) VALUES (3, 'Сыщик');



INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'Гражданская ул., д. 19'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Раскольников' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'Казначейская ул., д. 7, кв. 13'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Процентщица' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'Набережная канала Грибоедова, д. 104, кв. 13'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Сестра' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'Набережная канала Грибоедова, д. 104, кв. 13'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Сестра' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'Гостинница, сосед Сони Мармеладовой'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Свидригайлов' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'???'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Мориарти' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info)
	(SELECT 
		t_person.id_person,
		tcl_contacts_type.id_contacts_info,
		'777'
	FROM police.t_person, police.tcl_contacts_type
	WHERE	t_person.last_name = 'Мориарти' and 
		tcl_contacts_type.type_name = 'Телефон');



INSERT INTO police.t_employee(id_post,id_department,last_name,first_name,rank)
	(SELECT 
		tcl_post.id_post,
		t_department.id_department,
		'Холмс',
		'Шерлок',
		'Независимый консультант'
	FROM police.tcl_post, police.t_department
	WHERE	tcl_post.function = 'Сыщик' and 
		t_department.department_name = 'Скотлен-ярд');
INSERT INTO police.t_employee(id_post,id_department,last_name,first_name,patronymic,rank)
	(SELECT 
		tcl_post.id_post,
		t_department.id_department,
		'Следователь',
		'Порфирий',
		'Петрович',
		'Старший Сержант'
	FROM police.tcl_post, police.t_department
	WHERE	tcl_post.function = 'Следователь' and 
		t_department.department_name = '3-й полицейский участок Казанской части');
INSERT INTO police.t_employee(id_post,id_department,last_name,first_name,patronymic,rank)
	(SELECT 
		tcl_post.id_post,
		t_department.id_department,
		'НеЗнаю',
		'НеПомню',
		'Какой-тович',
		'Допустим Майор'
	FROM police.tcl_post, police.t_department
	WHERE	tcl_post.function = 'Начальник отдела' and 
		t_department.department_name = '3-й полицейский участок Казанской части');




INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info)
	(SELECT 
		t_employee.id_employee,
		tcl_contacts_type.id_contacts_info,
		'666'
	FROM police.t_employee, police.tcl_contacts_type
	WHERE	t_employee.last_name = 'Холмс' and 
		tcl_contacts_type.type_name = 'Телефон');
INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info)
	(SELECT 
		t_employee.id_employee,
		tcl_contacts_type.id_contacts_info,
		'Бэйкер-стрит, д. 221Б'
	FROM police.t_employee, police.tcl_contacts_type
	WHERE	t_employee.last_name = 'Холмс' and 
		tcl_contacts_type.type_name = 'Адрес');
INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info)
	(SELECT 
		t_employee.id_employee,
		tcl_contacts_type.id_contacts_info,
		'11-134-2323-43-23'
	FROM police.t_employee, police.tcl_contacts_type
	WHERE	t_employee.last_name = 'Следователь' and 
		tcl_contacts_type.type_name = 'Телефон');
INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info)
	(SELECT 
		t_employee.id_employee,
		tcl_contacts_type.id_contacts_info,
		'Всегда в отпуске'
	FROM police.t_employee, police.tcl_contacts_type
	WHERE	t_employee.last_name = 'НеЗнаю' and 
		tcl_contacts_type.type_name = 'Адрес');



INSERT INTO police.t_protocol(id_employee,id_case_name,status)
	(SELECT 
		t_employee.id_employee,
		tcl_case_name.id_case_name,
		false
	FROM police.t_employee, police.tcl_case_name
	WHERE	t_employee.last_name = 'Следователь' and 
		tcl_case_name.case_name = 'Двойное убийство');
INSERT INTO police.t_protocol(id_employee,id_case_name,status)
	(SELECT
		t_employee.id_employee,
		tcl_case_name.id_case_name,
		true
	FROM police.t_employee, police.tcl_case_name
	WHERE	t_employee.last_name = 'Холмс' and 
		tcl_case_name.case_name = 'Наполеон преступного мира');



INSERT INTO police.t_evidence(id_protocol,object_description,storage_box)
	(SELECT 
		t_protocol.id_protocol,
		'Топор',
		1
	FROM police.t_protocol
	WHERE	t_protocol.id_protocol = 1);
INSERT INTO police.t_evidence(id_protocol,object_description,storage_box)
	(SELECT 
		t_protocol.id_protocol,
		'Старухины драгоценности под камнем',
		1
	FROM police.t_protocol
	WHERE	t_protocol.id_protocol = 1);
INSERT INTO police.t_evidence(id_protocol,object_description,storage_box)
	(SELECT 
		t_protocol.id_protocol,
		'Отсутствуют, но будут найдены',
		2
	FROM police.t_protocol
	WHERE	t_protocol.id_protocol = 2);



INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person,id_cell)
	(SELECT 
		tcl_role.id_role,
		t_protocol.id_protocol,
		t_person.id_person,
		t_cell.id_cell
	FROM police.tcl_role, police.t_protocol, police.t_person, police.t_cell
	WHERE	tcl_role.name_role = 'Подсудимый' and
		t_protocol.id_protocol = 1 and 
		t_person.last_name = 'Раскольников' and
		t_cell.id_cell = 1);

INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person)
	(SELECT 
		tcl_role.id_role,
		t_protocol.id_protocol,
		t_person.id_person
	FROM police.tcl_role, police.t_protocol, police.t_person
	WHERE	tcl_role.name_role = 'Потерпевший' and
		t_protocol.id_protocol = 1 and
		t_person.last_name = 'Процентщица');
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person)
	(SELECT 
		tcl_role.id_role,
		t_protocol.id_protocol,
		t_person.id_person
	FROM police.tcl_role, police.t_protocol, police.t_person
	WHERE	tcl_role.name_role = 'Потерпевший' and
		t_protocol.id_protocol = 1 and
		t_person.last_name = 'Сестра');
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person)
	(SELECT 
		tcl_role.id_role,
		t_protocol.id_protocol,
		t_person.id_person
	FROM police.tcl_role, police.t_protocol, police.t_person
	WHERE	tcl_role.name_role = 'Свидетель' and
		t_protocol.id_protocol = 1 and
		t_person.last_name = 'Свидригайлов');
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person)
	(SELECT 
		tcl_role.id_role,
		t_protocol.id_protocol,
		t_person.id_person
	FROM police.tcl_role, police.t_protocol, police.t_person
	WHERE	tcl_role.name_role = 'Подозреваемый' and
		t_protocol.id_protocol = 2 and
		t_person.last_name = 'Мориарти');

end;