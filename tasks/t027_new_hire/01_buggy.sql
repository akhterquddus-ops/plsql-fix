create or replace view employee_directory_v as
select p.person_id, p.full_name, c.email, c.phone
  from hr_people p
  left join hr_contacts c on c.person_id = p.person_id
/
create or replace trigger employee_directory_ioi
instead of insert on employee_directory_v
for each row
begin
  -- New people are added through the directory view.
  insert into hr_people (person_id, full_name) values (:new.person_id, :new.full_name);
  insert into hr_contacts (person_id, email) values (:new.person_id, :new.email);
end employee_directory_ioi;
/
create or replace package onboarding_api as
  -- Adds a new hire to the staff directory.
  procedure add_hire(p_person_id in number, p_name in varchar2,
                     p_email in varchar2, p_phone in varchar2);
  function email_of(p_person_id in number) return varchar2;
  function phone_of(p_person_id in number) return varchar2;
end onboarding_api;
/
create or replace package body onboarding_api as
  procedure add_hire(p_person_id in number, p_name in varchar2,
                     p_email in varchar2, p_phone in varchar2) is
  begin
    insert into employee_directory_v (person_id, full_name, email, phone)
    values (p_person_id, p_name, p_email, p_phone);
  end add_hire;

  function email_of(p_person_id in number) return varchar2 is
    l_email employee_directory_v.email%type;
  begin
    select email into l_email from employee_directory_v where person_id = p_person_id;
    return l_email;
  end email_of;

  function phone_of(p_person_id in number) return varchar2 is
    l_phone employee_directory_v.phone%type;
  begin
    select phone into l_phone from employee_directory_v where person_id = p_person_id;
    return l_phone;
  end phone_of;
end onboarding_api;
/
