create or replace trigger bills_bu
before update of paid_amount on bills
for each row
begin
  -- A bill is PAID once the payments cover its amount, PARTIAL while part of it is open.
  if :new.paid_amount >= :new.amount then
    :new.status := 'PAID';
  elsif :new.paid_amount > 0 then
    :new.status := 'PARTIAL';
  else
    :new.status := 'OPEN';
  end if;
end bills_bu;
/
