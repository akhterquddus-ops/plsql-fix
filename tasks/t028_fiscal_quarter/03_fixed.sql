create or replace package body fiscal_calendar as
  function year_of(p_date in date) return number is
  begin
    return extract(year from p_date) + case when extract(month from p_date) >= 7 then 1 else 0 end;
  end year_of;

  function quarter_of(p_date in date) return number is
  begin
    return trunc(mod(extract(month from p_date) - 7 + 12, 12) / 3) + 1;
  end quarter_of;
end fiscal_calendar;
/
