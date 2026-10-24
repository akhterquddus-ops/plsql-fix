create or replace package fiscal_calendar as
  -- Fiscal year runs from 1 July to 30 June; fiscal year 2026 = 1 Jul 2025 to 30 Jun 2026.
  function year_of(p_date in date) return number;
  function quarter_of(p_date in date) return number;
end fiscal_calendar;
/
create or replace package body fiscal_calendar as
  function year_of(p_date in date) return number is
  begin
    return extract(year from p_date) + case when extract(month from p_date) >= 7 then 1 else 0 end;
  end year_of;

  function quarter_of(p_date in date) return number is
  begin
    return trunc(mod(extract(month from p_date) - 4 + 12, 12) / 3) + 1;
  end quarter_of;
end fiscal_calendar;
/
create or replace view quarterly_sales_v as
select region,
       fiscal_calendar.year_of(sale_date)    as fiscal_year,
       fiscal_calendar.quarter_of(sale_date) as fiscal_quarter,
       sum(amount)                           as total
  from sales
 group by region, fiscal_calendar.year_of(sale_date), fiscal_calendar.quarter_of(sale_date)
/
create or replace package sales_report as
  -- Sales total of a region for one fiscal quarter.
  function quarter_total(p_region in varchar2, p_year in number, p_quarter in number) return number;
end sales_report;
/
create or replace package body sales_report as
  function quarter_total(p_region in varchar2, p_year in number, p_quarter in number) return number is
    l_total number;
  begin
    select nvl(sum(total), 0)
      into l_total
      from quarterly_sales_v
     where region = p_region and fiscal_year = p_year and fiscal_quarter = p_quarter;
    return l_total;
  end quarter_total;
end sales_report;
/
