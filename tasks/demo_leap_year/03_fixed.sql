create or replace function is_leap_year(p_year in pls_integer) return boolean is
begin
  return (mod(p_year, 4) = 0 and mod(p_year, 100) <> 0) or mod(p_year, 400) = 0;
end;
/
show errors
exit
