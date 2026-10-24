drop table if exists order_status_log purge
/
drop table if exists shop_orders purge
/
create table shop_orders (
  order_id number primary key,
  customer varchar2(40) not null,
  status   varchar2(10) not null
)
/
create table order_status_log (
  log_id     number generated always as identity primary key,
  order_id   number not null,
  old_status varchar2(10),
  new_status varchar2(10),
  changed_at date default sysdate
)
/
