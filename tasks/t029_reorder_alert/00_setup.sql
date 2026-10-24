drop table if exists reorder_requests purge
/
drop table if exists inventory_levels purge
/
create table inventory_levels (
  sku           varchar2(10) primary key,
  on_hand       number not null,
  reorder_point number not null
)
/
create table reorder_requests (
  request_id   number generated always as identity primary key,
  sku          varchar2(10) not null,
  requested_on date default sysdate
)
/
