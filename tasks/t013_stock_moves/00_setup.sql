drop table if exists stock_moves purge
/
drop table if exists warehouse_bins purge
/
create table warehouse_bins (
  bin_code  varchar2(10) primary key,
  item_code varchar2(20) not null,
  qty       number not null
)
/
create table stock_moves (
  move_id   number generated always as identity primary key,
  bin_code  varchar2(10) not null references warehouse_bins (bin_code),
  direction varchar2(3) not null check (direction in ('IN', 'OUT')),
  qty       number not null check (qty > 0),
  moved_at  timestamp default systimestamp not null
)
/
