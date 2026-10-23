create or replace package body sla_policy as
  function hours_for(p_priority in varchar2) return number is
  begin
    return case p_priority
             when 'P1' then 4
             when 'P2' then 8
             when 'P3' then 24
           end;
  end hours_for;
end sla_policy;
/
