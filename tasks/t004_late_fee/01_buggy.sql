create or replace package t004_util as
  -- Whole days an item is overdue (0 if returned on or before the due date).
  function days_late(p_due in date, p_returned in date) return number;
end t004_util;
/
create or replace package body t004_util as
  function days_late(p_due in date, p_returned in date) return number is
  begin
    return greatest(trunc(p_returned) - trunc(p_due), 0) * 24;
  end days_late;
end t004_util;
/
create or replace package t004_loans_api as
  -- Late fee for a returned loan: 0.50 per overdue day.
  function late_fee(p_loan_id in number) return number;
end t004_loans_api;
/
create or replace package body t004_loans_api as
  c_daily_fee constant number := 0.50;

  function late_fee(p_loan_id in number) return number is
    l_due      t004_loans.due_date%type;
    l_returned t004_loans.returned_date%type;
  begin
    select due_date, returned_date
      into l_due, l_returned
      from t004_loans
     where loan_id = p_loan_id;
    if l_returned is null then
      return 0;
    end if;
    return t004_util.days_late(l_due, l_returned) * c_daily_fee;
  end late_fee;
end t004_loans_api;
/
