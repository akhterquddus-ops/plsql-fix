create or replace package test_format_phone as
  --%suite(t020 phone format)

  --%test(plain 11-digit number)
  procedure plain_number;

  --%test(number typed with spaces)
  procedure with_spaces;

  --%test(short number is left unchanged)
  procedure short_number;
end test_format_phone;
/
create or replace package body test_format_phone as
  procedure plain_number is
  begin
    ut.expect(format_phone('03001234567')).to_equal('0300-1234567');
  end plain_number;

  procedure with_spaces is
  begin
    ut.expect(format_phone('0321 765 4321')).to_equal('0321-7654321');
  end with_spaces;

  procedure short_number is
  begin
    ut.expect(format_phone('12345')).to_equal('12345');
  end short_number;
end test_format_phone;
/
