create or replace trigger bill_payments_ai
after insert on bill_payments
for each row
begin
  -- Adds each payment to the paid amount of its bill.
  update bills set paid_amount = paid_amount + :new.amount where bill_id = :new.bill_id;
end bill_payments_ai;
/
create or replace trigger bills_bu
before update of paid_amount on bills
for each row
begin
  -- A bill is PAID once the payments cover its amount, PARTIAL while part of it is open.
  if :new.paid_amount > :new.amount then
    :new.status := 'PAID';
  elsif :new.paid_amount > 0 then
    :new.status := 'PARTIAL';
  else
    :new.status := 'OPEN';
  end if;
end bills_bu;
/
create or replace package billing_api as
  -- Records a payment against a bill.
  procedure pay(p_bill_id in number, p_amount in number);
end billing_api;
/
create or replace package body billing_api as
  procedure pay(p_bill_id in number, p_amount in number) is
  begin
    insert into bill_payments (bill_id, amount) values (p_bill_id, p_amount);
  end pay;
end billing_api;
/
