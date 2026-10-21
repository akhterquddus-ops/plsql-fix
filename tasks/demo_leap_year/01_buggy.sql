create or replace function is_leap_year(p_year in pls_integer) return boolean is
begin
  return mod(p_year, 4) = 0;   -- BUG: ignores the 100/400 century rule
end;
/
show errors
exit
