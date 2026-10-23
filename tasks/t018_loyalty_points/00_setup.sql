drop table if exists loyalty_purchases purge
/
drop table if exists loyalty_members purge
/
create table loyalty_members (
  member_id number primary key,
  name      varchar2(60) not null,
  points    number default 0 not null
)
/
create table loyalty_purchases (
  purchase_id number generated always as identity primary key,
  member_id   number not null references loyalty_members (member_id),
  amount      number(10,2) not null
)
/
