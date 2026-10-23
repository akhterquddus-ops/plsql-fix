drop table if exists bank_accounts purge
/
create table bank_accounts (
  account_no      varchar2(12) primary key,
  holder          varchar2(60) not null,
  balance         number(12,2) not null,
  overdraft_limit number(12,2) default 0 not null
)
/
