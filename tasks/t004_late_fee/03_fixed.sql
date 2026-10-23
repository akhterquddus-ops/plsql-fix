create or replace package body t004_util as
  function days_late(p_due in date, p_returned in date) return number is
  begin
    return greatest(trunc(p_returned) - trunc(p_due), 0);
  end days_late;
end t004_util;
/
