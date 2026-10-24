drop table if exists sales purge
/
create table sales (
  sale_id   number primary key,
  region    varchar2(10) not null,
  sale_date date not null,
  amount    number(12,2) not null
)
/
