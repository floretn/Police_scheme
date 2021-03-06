﻿create index index_for_t_cell on police.t_cell (id_cell);
create index index_for_t_department on police.t_department (id_department);
create index index_for_t_employee on police.t_employee (id_employee);
create index index_for_t_employee_contacts on police.t_employee_contacts (id_employee_contacts);
create index index_for_t_evidence on police.t_evidence (id_evidence);
create index index_for_t_investigation_participants on police.t_investigation_participants (id_participants);
create index index_for_t_person on police.t_person (id_person);
create index index_for_t_person_contacts on police.t_person_contacts (id_person_contacts);
create index index_for_t_protocol on police.t_protocol (id_protocol);
create index index_for_tcl_case_name on police.tcl_case_name (id_case_name);
create index index_for_tcl_contacts_type on police.tcl_contacts_type (id_contacts_info);
create index index_for_tcl_post on police.tcl_post (id_post);
create index index_for_tcl_role on police.tcl_role (id_role);

create index index_for_t_protocol_by_employee on police.t_protocol (id_employee);
create index index_for_t_investigation_participants_by_protocol on police.t_investigation_participants (id_protocol);
create index index_for_t_evidence_by_protocol on police.t_evidence (id_protocol);
create index index_for_t_employee_by_department on police.t_employee (id_department);
create index index_for_t_employee_contacts_by_employee on police.t_employee_contacts (id_employee);
create index index_for_t_person_contacts_by_person on police.t_person_contacts (id_person);
create index index_for_t_investigation_participants_by_person on police.t_investigation_participants (id_person);