create or replace package t003_fees as
  -- Transfer fee: 1% of the amount, at least 1.00 and at most 10.00.
  function fee_for(p_amount in number) return number;
end t003_fees;
/
create or replace package body t003_fees as
  c_rate    constant number := 0.01;
  c_min_fee constant number := 1;
  c_max_fee constant number := 10;

  function fee_for(p_amount in number) return number is
  begin
    return greatest(least(round(p_amount * c_rate, 2), c_min_fee), c_max_fee);
  end fee_for;
end t003_fees;
/
create or replace package t003_ledger_pkg as
  -- Records a transfer: takes amount + fee from the source, gives amount to the target.
  procedure post_transfer(p_from in number, p_to in number, p_amount in number);
end t003_ledger_pkg;
/
create or replace package body t003_ledger_pkg as
  procedure add_entry(p_account in number, p_type in varchar2, p_amount in number) is
  begin
    insert into t003_ledger (account_id, entry_type, amount)
    values (p_account, p_type, p_amount);

    update t003_accounts
       set balance = balance + case p_type when 'CREDIT' then p_amount else -p_amount end
     where account_id = p_account;
  end add_entry;

  procedure post_transfer(p_from in number, p_to in number, p_amount in number) is
    l_fee number := t003_fees.fee_for(p_amount);
  begin
    add_entry(p_from, 'DEBIT',  p_amount);
    add_entry(p_from, 'FEE',    l_fee);
    add_entry(p_to,   'CREDIT', p_amount);
  end post_transfer;
end t003_ledger_pkg;
/
create or replace package t003_accounts_api as
  -- Moves money between two accounts.
  procedure transfer(p_from in number, p_to in number, p_amount in number);
  function balance_of(p_account in number) return number;
end t003_accounts_api;
/
create or replace package body t003_accounts_api as
  function balance_of(p_account in number) return number is
    l_balance t003_accounts.balance%type;
  begin
    select balance into l_balance from t003_accounts where account_id = p_account;
    return l_balance;
  end balance_of;

  procedure transfer(p_from in number, p_to in number, p_amount in number) is
  begin
    if p_amount is null or p_amount <= 0 then
      raise_application_error(-20002, 'Amount must be positive');
    end if;
    if balance_of(p_from) < p_amount then
      raise_application_error(-20001, 'Insufficient funds');
    end if;
    t003_ledger_pkg.post_transfer(p_from, p_to, p_amount);
  end transfer;
end t003_accounts_api;
/
