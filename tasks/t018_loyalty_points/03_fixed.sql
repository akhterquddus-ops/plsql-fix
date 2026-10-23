create or replace package body points_rules as
  function points_for(p_amount in number) return number is
  begin
    return floor(nvl(p_amount, 0) / 100);
  end points_for;
end points_rules;
/
