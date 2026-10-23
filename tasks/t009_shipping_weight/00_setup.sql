drop table if exists t009_order_items purge
/
create table t009_order_items (
  order_id number not null,
  item_no  number not null,
  price    number(10,2) not null,
  weight_g number not null,
  qty      number not null,
  constraint t009_order_items_pk primary key (order_id, item_no)
)
/
