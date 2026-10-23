create or replace package body t007_customer_q as
  function engaged_count(p_region in varchar2) return number is
    l_count number;
  begin
    select count(*)
      into l_count
      from t007_customers
     where region = p_region
       and (status = 'ACTIVE' or vip = 'Y');
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
