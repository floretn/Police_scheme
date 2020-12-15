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



INSERT INTO police.t_cell (number_of_places, employed_places) VALUES (5, 1);


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



INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info) values (1, 2, 'Гражданская ул., д. 19');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info) values (2, 2, 'Казначейская ул., д. 7, кв. 13');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info) values (4, 2, 'Набережная канала Грибоедова, д. 104, кв. 13');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info) values (3, 2, 'Гостинница, сосед Сони Мармеладовой');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info) values (5, 2, '???');
INSERT INTO police.t_person_contacts(id_person,id_contacts_info,value_contacts_info) values (5, 1, '777');



INSERT INTO police.t_employee(id_post,id_department,last_name,first_name,rank) values (3, 2, 'Холмс', 'Шерлок', 'Независимый консультант');
INSERT INTO police.t_employee(id_post,id_department,last_name,first_name,patronymic,rank) values (2, 1, 'Следователь', 'Порфирий', 'Петрович', 'Старший сержант');
INSERT INTO police.t_employee(id_post,id_department,last_name,first_name,patronymic,rank) values (1, 1, 'НеЗнаю', 'НеПомню', 'Какой-тович', 'Допустим Майор');




INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info) values (1, 2, '666');
INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info) values (1, 1, 'Бэйкер-стрит, д. 221Б');
INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info) values (2, 2, '11-134-2323-43-23');
INSERT INTO police.t_employee_contacts(id_employee,id_contacts_info,value_contacts_info) values (3, 1, 'Всегда в отпуске');



INSERT INTO police.t_protocol(id_employee,id_case_name,status) values (2, 1, false);
INSERT INTO police.t_protocol(id_employee,id_case_name,status) values (1, 2, true);



INSERT INTO police.t_evidence(id_protocol,object_description,storage_box) values (1, 'Топор', 1);
INSERT INTO police.t_evidence(id_protocol,object_description,storage_box) values (1, 'Старухины драгоценности под камнем', 1);
INSERT INTO police.t_evidence(id_protocol,object_description,storage_box) values (2, 'Отсутствуют, но будут найдены', 2);



INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person,id_cell) values (4, 1, 1, 1);
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person) values (3, 1, 2);
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person) values (3, 1, 4);
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person) values (2, 1, 3);
INSERT INTO police.t_investigation_participants(id_role,id_protocol,id_person) values (1, 2, 5);

end;