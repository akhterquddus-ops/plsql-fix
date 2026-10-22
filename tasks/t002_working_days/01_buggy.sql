create or replace function t002_working_days(
  p_start in date,
  p_end   in date
) return pls_integer is
  -- Working days (Monday to Friday) between p_start and p_end, counting both dates.
  l_day   date        := trunc(p_start);
  l_count pls_integer := 0;
begin
  if p_start is null or p_end is null or trunc(p_end) < trunc(p_start) then
    return 0;
  end if;
  while l_day < trunc(p_end) loop
    if l_day - trunc(l_day, 'IW') < 5 then
      l_count := l_count + 1;
    end if;
    l_day := l_day + 1;
  end loop;
  return l_count;
end t002_working_days;
/
