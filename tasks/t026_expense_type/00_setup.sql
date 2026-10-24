drop table if exists expense_lines purge
/
create table expense_lines (
  line_id      number generated always as identity primary key,
  claim_id     number not null,
  amount       number(12,2) not null,
  currency     varchar2(3) not null,
  rate_to_base number(12,6) not null
)
/
