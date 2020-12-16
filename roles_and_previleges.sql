/* 
Дропнуть всё, если роли и политики с такими именами уже существуют
DROP POLICY IF EXISTS t_protocol_policy ON police.t_protocol;
DROP POLICY IF EXISTS t_evidence_policy ON police.t_evidence;
REVOKE USAGE ON SCHEMA police FROM ip_manager;
REVOKE USAGE ON SCHEMA police FROM hr_manager;
REVOKE USAGE ON SCHEMA police FROM sherlock_holms;
REVOKE USAGE ON SCHEMA police FROM porfiriy_petrovich;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA police FROM minister_mvd CASCADE;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA police FROM ip_manager CASCADE;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA police FROM hr_manager CASCADE;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA police FROM sherlock_holms CASCADE;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA police FROM porfiriy_petrovich CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA police FROM minister_mvd CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA police FROM ip_manager CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA police FROM hr_manager CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA police FROM sherlock_holms CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA police FROM porfiriy_petrovich CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM minister_mvd CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM ip_manager CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM hr_manager CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM sherlock_holms CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM porfiriy_petrovich CASCADE;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA police FROM minister_mvd CASCADE;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA police FROM ip_manager CASCADE;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA police FROM hr_manager CASCADE;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA police FROM sherlock_holms CASCADE;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA police FROM porfiriy_petrovich CASCADE;
DROP ROLE IF EXISTS admins;
DROP ROLE IF EXISTS managers;
DROP ROLE IF EXISTS staff;
DROP USER IF EXISTS minister_mvd;
DROP USER IF EXISTS ip_manager;
DROP USER IF EXISTS hr_manager;
DROP USER IF EXISTS sherlock_holms;
DROP USER IF EXISTS porfiriy_petrovich;
*/
-- Создание групповых ролей
CREATE ROLE admins;
CREATE ROLE managers;
CREATE ROLE staff;

-- admins user
  --  создание
CREATE USER minister_mvd WITH 
LOGIN
ENCRYPTED PASSWORD 'minister_mvd'
IN GROUP admins; 
  --  выдача прав
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
ON ALL TABLES IN SCHEMA police
TO minister_mvd;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA police
TO minister_mvd;

GRANT CREATE, CONNECT, TEMPORARY
ON DATABASE postgres
TO minister_mvd;

GRANT USAGE, SELECT, UPDATE
ON ALL SEQUENCES IN SCHEMA police
TO minister_mvd;

-- managers users
  -- user ip_manager
    -- создание
CREATE USER ip_manager WITH NOSUPERUSER
LOGIN
ENCRYPTED PASSWORD 'ip_manager'
IN GROUP managers; 
     -- выдача прав
GRANT CONNECT
ON DATABASE postgres
TO ip_manager;

GRANT USAGE ON SCHEMA police
TO ip_manager;

GRANT SELECT, INSERT, DELETE, UPDATE 
ON TABLE police.t_person,
	police.t_person_contacts,
	police.t_investigation_participants,
	police.tcl_role
TO ip_manager;
  -- user hr_manager
    -- создание
CREATE USER hr_manager WITH NOSUPERUSER
LOGIN
ENCRYPTED PASSWORD 'hr_manager'
IN GROUP managers; 
    -- выдача прав
GRANT CONNECT
ON DATABASE postgres
TO hr_manager;

GRANT USAGE ON SCHEMA police
TO hr_manager;

GRANT SELECT, INSERT, DELETE, UPDATE 
ON TABLE police.t_employee,
	police.t_employee_contacts,
	police.tcl_post
TO hr_manager;

-- staff users
 -- hr_manager
  -- создание
CREATE USER sherlock_holms WITH NOSUPERUSER
LOGIN
ENCRYPTED PASSWORD 'sherlock_holms'
IN GROUP staff; 
  -- выдача прав
GRANT USAGE ON SCHEMA police
TO sherlock_holms;

GRANT SELECT, INSERT
ON TABLE police.t_protocol,
	police.tcl_case_name,
	police.t_evidence
TO sherlock_holms;
 -- porfiriy_petrovich
   -- создание
CREATE USER porfiriy_petrovich WITH NOSUPERUSER
LOGIN
ENCRYPTED PASSWORD 'porfiriy_petrovich'
IN GROUP staff; 
  -- выдача прав
GRANT USAGE ON SCHEMA police
TO porfiriy_petrovich;

GRANT SELECT, INSERT
ON TABLE police.t_protocol,
	police.t_evidence
TO porfiriy_petrovich;

-- Добавления свойства учета политики защиты строк для пользователей групповых ролей
ALTER ROLE staff WITH NOBYPASSRLS;

-- Включение политики защиты строк для таблиц, которые могут быть использованы совместно
ALTER TABLE police.t_protocol ENABLE ROW LEVEL SECURITY;
ALTER TABLE police.t_evidence ENABLE ROW LEVEL SECURITY;

-- Введение конкретных политик защиты строк
CREATE POLICY t_protocol_policy ON police.t_protocol
TO staff
USING ((CURRENT_USER = 'sherlock_holms' AND (id_employee = 1)) OR
				(CURRENT_USER = 'porfiriy_petrovich' AND (id_employee = 2)));

CREATE POLICY t_evidence_policy ON police.t_evidence
TO staff
USING ((CURRENT_USER = 'sherlock_holms' AND (storage_box = 2) OR
				(CURRENT_USER = 'porfiriy_petrovich' AND (storage_box = 1))));
