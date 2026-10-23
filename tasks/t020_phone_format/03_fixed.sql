create or replace function format_phone(p_number in varchar2) return varchar2 is
  -- Formats an 11-digit mobile number as 0300-1234567; other input is returned unchanged.
  l_digits varchar2(40) := regexp_replace(p_number, '[^0-9]', '');
begin
  if length(l_digits) = 11 then
    return substr(l_digits, 1, 4) || '-' || substr(l_digits, 5);
  end if;
  return p_number;
end format_phone;
/
