drop table if exists shop_customers purge
/
drop table if exists discount_tiers purge
/
create table shop_customers (
  customer_id  number primary key,
  name         varchar2(40) not null,
  annual_spend number(12,2) not null
)
/
create table discount_tiers (
  tier_name    varchar2(10) primary key,
  min_spend    number(12,2) not null,
  discount_pct number(5,2) not null
)
/
