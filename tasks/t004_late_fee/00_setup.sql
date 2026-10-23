drop table if exists t004_loans purge
/
create table t004_loans (
  loan_id       number primary key,
  member_id     number not null,
  due_date      date not null,
  returned_date date
)
/
