drop table if exists t003_ledger purge
/
drop table if exists t003_accounts purge
/
create table t003_accounts (
  account_id number primary key,
  balance    number(12,2) not null
)
/
create table t003_ledger (
  entry_id   number generated always as identity primary key,
  account_id number not null references t003_accounts (account_id),
  entry_type varchar2(10) not null,
  amount     number(12,2) not null,
  created_at timestamp default systimestamp not null
)
/
