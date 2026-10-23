create or replace package test_headcount_report as
  --%suite(t016 headcount)

  --%beforeeach
  procedure setup_data;

  --%test(IT counts permanent and fixed-term staff, not leavers)
  procedure it_dept;

  --%test(HR counts its permanent employee)
  procedure hr_dept;

  --%test(department without staff)
  procedure empty_dept;
end test_headcount_report;
/
create or replace package body test_headcount_report as
  procedure setup_data is
  begin
    insert into staff values (1, 'Ali',   'IT', null);
    insert into staff values (2, 'Bina',  'IT', date '2099-12-31');
    insert into staff values (3, 'Chand', 'IT', date '2020-01-31');
    insert into staff values (4, 'Dua',   'HR', null);
  end setup_data;

  procedure it_dept is
  begin
    ut.expect(headcount_report.headcount('IT')).to_equal(2);
  end it_dept;

  procedure hr_dept is
  begin
    ut.expect(headcount_report.headcount('HR')).to_equal(1);
  end hr_dept;

  procedure empty_dept is
  begin
    ut.expect(headcount_report.headcount('OPS')).to_equal(0);
  end empty_dept;
end test_headcount_report;
/
