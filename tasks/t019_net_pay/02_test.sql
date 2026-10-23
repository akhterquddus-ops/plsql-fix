create or replace package test_payroll_api as
  --%suite(t019 net pay)

  --%test(middle salary)
  procedure middle_salary;

  --%test(high salary hits the pension cap)
  procedure high_salary;

  --%test(low salary)
  procedure low_salary;
end test_payroll_api;
/
create or replace package body test_payroll_api as
  procedure middle_salary is
  begin
    ut.expect(payroll_api.net_pay(50000)).to_equal(46500);
  end middle_salary;

  procedure high_salary is
  begin
    ut.expect(payroll_api.net_pay(100000)).to_equal(94000);
  end high_salary;

  procedure low_salary is
  begin
    ut.expect(payroll_api.net_pay(20000)).to_equal(18600);
  end low_salary;
end test_payroll_api;
/
