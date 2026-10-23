create or replace trigger bank_accounts_bu
before update of balance on bank_accounts
for each row
begin
  -- The balance may not go below minus the overdraft limit.
  if :new.balance < -:new.overdraft_limit then
    raise_application_error(-20070, 'Overdraft limit exceeded');
  end if;
end bank_accounts_bu;
/
