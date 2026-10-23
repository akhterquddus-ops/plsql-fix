create or replace trigger bank_accounts_bu
before update of balance on bank_accounts
for each row
begin
  -- The balance may not go below minus the overdraft limit.
  if :old.balance < -:new.overdraft_limit then
    raise_application_error(-20070, 'Overdraft limit exceeded');
  end if;
end bank_accounts_bu;
/
create or replace package atm_api as
  -- Withdraws cash. Returns OK, or DECLINED if the overdraft limit would be exceeded.
  function withdraw(p_account_no in varchar2, p_amount in number) return varchar2;
  function balance_of(p_account_no in varchar2) return number;
end atm_api;
/
create or replace package body atm_api as
  function withdraw(p_account_no in varchar2, p_amount in number) return varchar2 is
    e_limit exception;
    pragma exception_init(e_limit, -20070);
  begin
    update bank_accounts
       set balance = balance - p_amount
     where account_no = p_account_no;
    return 'OK';
  exception
    when e_limit then
      return 'DECLINED';
  end withdraw;

  function balance_of(p_account_no in varchar2) return number is
    l_balance bank_accounts.balance%type;
  begin
    select balance into l_balance from bank_accounts where account_no = p_account_no;
    return l_balance;
  end balance_of;
end atm_api;
/
