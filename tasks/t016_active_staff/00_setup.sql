drop table if exists staff purge
/
create table staff (
  staff_id  number primary key,
  full_name varchar2(60) not null,
  dept_code varchar2(10) not null,
  end_date  date
)
/
