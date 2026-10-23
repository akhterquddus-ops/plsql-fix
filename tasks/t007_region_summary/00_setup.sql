drop table if exists t007_customers purge
/
create table t007_customers (
  customer_id number primary key,
  name        varchar2(50) not null,
  region      varchar2(10) not null,
  status      varchar2(10) not null,
  vip         char(1) default 'N' not null
)
/
