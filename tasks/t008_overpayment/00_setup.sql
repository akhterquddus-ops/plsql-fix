drop table if exists t008_invoices purge
/
create table t008_invoices (
  invoice_id  number primary key,
  customer_id number not null,
  open_amount number(12,2) not null
)
/
