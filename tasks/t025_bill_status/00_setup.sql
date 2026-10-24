drop table if exists bill_payments purge
/
drop table if exists bills purge
/
create table bills (
  bill_id     number primary key,
  customer    varchar2(40) not null,
  amount      number(10,2) not null,
  paid_amount number(10,2) default 0 not null,
  status      varchar2(10) default 'OPEN' not null
)
/
create table bill_payments (
  payment_id number generated always as identity primary key,
  bill_id    number not null references bills (bill_id),
  amount     number(10,2) not null,
  paid_on    date default sysdate
)
/
