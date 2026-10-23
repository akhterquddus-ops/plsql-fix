create or replace package sla_policy as
  -- Response time in hours by priority: P1 = 4, P2 = 8, P3 = 24.
  function hours_for(p_priority in varchar2) return number;
end sla_policy;
/
create or replace package body sla_policy as
  function hours_for(p_priority in varchar2) return number is
  begin
    return case p_priority
             when 'P1' then 4
             when 'P2' then 24
             when 'P3' then 8
           end;
  end hours_for;
end sla_policy;
/
create or replace package ticket_api as
  -- Time by which a ticket must be answered.
  function due_at(p_opened in date, p_priority in varchar2) return date;
end ticket_api;
/
create or replace package body ticket_api as
  function due_at(p_opened in date, p_priority in varchar2) return date is
  begin
    return p_opened + sla_policy.hours_for(p_priority) / 24;
  end due_at;
end ticket_api;
/
