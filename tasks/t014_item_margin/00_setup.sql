drop table if exists goods_receipts purge
/
drop table if exists catalogue_items purge
/
create table catalogue_items (
  sku        varchar2(20) primary key,
  name       varchar2(60) not null,
  list_price number(10,2) not null
)
/
create table goods_receipts (
  receipt_id number generated always as identity primary key,
  sku        varchar2(20) not null references catalogue_items (sku),
  qty        number not null,
  total_cost number(12,2) not null
)
/
