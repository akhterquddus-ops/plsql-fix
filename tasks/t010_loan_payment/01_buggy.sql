create or replace package t010_math as
  -- Annuity factor for a periodic rate and a number of periods:
  -- rate / (1 - (1 + rate)^-periods), or 1 / periods when the rate is 0.
  function annuity_factor(p_rate in number, p_periods in number) return number;
end t010_math;
/
create or replace package body t010_math as
  function annuity_factor(p_rate in number, p_periods in number) return number is
  begin
    if p_rate = 0 then
      return 1 / p_periods;
    end if;
    return p_rate / (1 - power(1 + p_rate, -p_periods));
  end annuity_factor;
end t010_math;
/
create or replace package t010_finance_pkg as
  -- Monthly payment for a loan, rounded to cents.
  function payment(p_principal in number, p_annual_pct in number, p_months in number)
    return number;
end t010_finance_pkg;
/
create or replace package body t010_finance_pkg as
  function payment(p_principal in number, p_annual_pct in number, p_months in number)
    return number is
    l_monthly_rate number := p_annual_pct / 1200;
  begin
    return round(p_principal * t010_math.annuity_factor(p_months, l_monthly_rate), 2);
  end payment;
end t010_finance_pkg;
/
create or replace package t010_loans_api as
  function monthly_payment(p_loan_id in number) return number;
end t010_loans_api;
/
create or replace package body t010_loans_api as
  function monthly_payment(p_loan_id in number) return number is
    l_loan t010_loans%rowtype;
  begin
    select * into l_loan from t010_loans where loan_id = p_loan_id;
    return t010_finance_pkg.payment(l_loan.principal, l_loan.annual_pct, l_loan.months);
  end monthly_payment;
end t010_loans_api;
/
