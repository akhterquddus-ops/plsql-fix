drop table if exists t001_order_lines purge
/
drop table if exists t001_orders purge
/
create table t001_orders (
  order_id    number primary key,
  customer_id number not null,
  status      varchar2(10) default 'OPEN' not null
)
/
create table t001_order_lines (
  order_id     number not null references t001_orders (order_id),
  line_no      number not null,
  product_code varchar2(20) not null,
  qty          number not null,
  unit_price   number(10,2) not null,
  discount_pct number(5,2) default 0 not null,
  constraint t001_order_lines_pk primary key (order_id, line_no)
)
/
