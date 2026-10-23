create or replace function t011_full_name(
  p_first  in varchar2,
  p_middle in varchar2,
  p_last   in varchar2
) return varchar2 is
  -- Display name: first, middle and last name separated by single spaces.
begin
  return trim(p_first || ' ' || p_middle || ' ' || p_last);
end t011_full_name;
/
