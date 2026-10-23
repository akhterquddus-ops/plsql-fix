create or replace package t007_customer_q as
  -- Customers in a region who are active or VIP.
  function engaged_count(p_region in varchar2) return number;
  -- All customers in a region.
  function total_count(p_region in varchar2) return number;
end t007_customer_q;
/
create or replace package body t007_customer_q as
  function engaged_count(p_region in varchar2) return number is
    l_count number;
  begin
    select count(*)
      into l_count
      from t007_customers
     where region = p_region
       and status = 'ACTIVE'
        or vip = 'Y';
    return l_count;
  end engaged_count;

  function total_count(p_region in varchar2) return number is
    l_count number;
  begin
    select count(*)
      into l_count
      from t007_customers
     where region = p_region;
    return l_count;
  end total_count;
end t007_customer_q;
/
create or replace package t007_reports_api as
  -- One-line summary, e.g. 'NORTH: 2 engaged of 3'.
  function region_summary(p_region in varchar2) return varchar2;
end t007_reports_api;
/
create or replace package body t007_reports_api as
  function region_summary(p_region in varchar2) return varchar2 is
  begin
    return p_region || ': '
        || to_char(t007_customer_q.engaged_count(p_region)) || ' engaged of '
        || to_char(t007_customer_q.total_count(p_region));
  end region_summary;
end t007_reports_api;
/
