create or replace package test_t010_loans_api as
  --%suite(t010 loan payments)

  --%beforeeach
  procedure setup_data;

  --%test(one-year loan at 12 percent)
  procedure one_year_12pct;

  --%test(two-year loan at 6 percent)
  procedure two_years_6pct;

  --%test(interest-free loan)
  procedure interest_free;
end test_t010_loans_api;
/
create or replace package body test_t010_loans_api as
  procedure setup_data is
  begin
    insert into t010_loans values (1, 120000, 12, 12);
    insert into t010_loans values (2,  50000,  6, 24);
    insert into t010_loans values (3, 120000,  0, 12);
  end setup_data;

  procedure one_year_12pct is
  begin
    ut.expect(t010_loans_api.monthly_payment(1)).to_equal(10661.85);
  end one_year_12pct;

  procedure two_years_6pct is
  begin
    ut.expect(t010_loans_api.monthly_payment(2)).to_equal(2216.03);
  end two_years_6pct;

  procedure interest_free is
  begin
    ut.expect(t010_loans_api.monthly_payment(3)).to_equal(10000);
  end interest_free;
end test_t010_loans_api;
/
