drop table if exists t005_stock purge
/
create table t005_stock (
  product_id number primary key,
  on_hand    number not null,
  reserved   number
)
/
