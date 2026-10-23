create or replace function t006_income_tax(p_annual_income in number) return number is
  -- Annual income tax:
  --   up to 600,000              no tax
  --   600,001 to 1,200,000       5% of the amount above 600,000
  --   above 1,200,000            30,000 plus 15% of the amount above 1,200,000
begin
  if p_annual_income is null or p_annual_income <= 600000 then
    return 0;
  elsif p_annual_income <= 1200000 then
    return round(p_annual_income * 0.05, 2);
  else
    return round(30000 + (p_annual_income - 1200000) * 0.15, 2);
  end if;
end t006_income_tax;
/
