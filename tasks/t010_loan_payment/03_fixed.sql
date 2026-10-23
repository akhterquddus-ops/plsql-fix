create or replace package body t010_finance_pkg as
  function payment(p_principal in number, p_annual_pct in number, p_months in number)
    return number is
    l_monthly_rate number := p_annual_pct / 1200;
  begin
    return round(p_principal * t010_math.annuity_factor(l_monthly_rate, p_months), 2);
  end payment;
end t010_finance_pkg;
/
