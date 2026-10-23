drop table if exists t010_loans purge
/
create table t010_loans (
  loan_id    number primary key,
  principal  number(12,2) not null,
  annual_pct number(5,2) not null,
  months     number not null
)
/
