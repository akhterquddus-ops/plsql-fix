drop table if exists hr_contacts purge
/
drop table if exists hr_people purge
/
create table hr_people (
  person_id number primary key,
  full_name varchar2(60) not null
)
/
create table hr_contacts (
  person_id number primary key references hr_people (person_id),
  email     varchar2(80),
  phone     varchar2(20)
)
/
