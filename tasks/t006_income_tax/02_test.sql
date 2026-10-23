create or replace package test_t006_income_tax as
  --%suite(t006 income tax)

  --%test(income below the threshold is not taxed)
  procedure below_threshold;

  --%test(middle bracket taxes only the part above 600000)
  procedure middle_bracket;

  --%test(top of the middle bracket)
  procedure bracket_boundary;

  --%test(top bracket)
  procedure top_bracket;
end test_t006_income_tax;
/
create or replace package body test_t006_income_tax as
  procedure below_threshold is
  begin
    ut.expect(t006_income_tax(500000)).to_equal(0);
  end below_threshold;

  procedure middle_bracket is
  begin
    ut.expect(t006_income_tax(1000000)).to_equal(20000);
  end middle_bracket;

  procedure bracket_boundary is
  begin
    ut.expect(t006_income_tax(1200000)).to_equal(30000);
  end bracket_boundary;

  procedure top_bracket is
  begin
    ut.expect(t006_income_tax(1500000)).to_equal(75000);
  end top_bracket;
end test_t006_income_tax;
/
