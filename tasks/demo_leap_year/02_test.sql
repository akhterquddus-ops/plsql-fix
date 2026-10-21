create or replace package test_is_leap_year as
  --%suite(is_leap_year)

  --%test(2024 is a leap year)
  procedure year_2024;

  --%test(1900 is not a leap year)
  procedure year_1900;

  --%test(2000 is a leap year)
  procedure year_2000;
end;
/
create or replace package body test_is_leap_year as
  procedure year_2024 is begin ut.expect(is_leap_year(2024)).to_be_true();  end;
  procedure year_1900 is begin ut.expect(is_leap_year(1900)).to_be_false(); end;
  procedure year_2000 is begin ut.expect(is_leap_year(2000)).to_be_true();  end;
end;
/
show errors
exit
