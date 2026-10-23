create or replace package test_t004_loans_api as
  --%suite(t004 late fees)

  --%beforeeach
  procedure setup_data;

  --%test(three days late costs 1.50)
  procedure three_days_late;

  --%test(returned on the due date costs nothing)
  procedure on_time;

  --%test(returned early costs nothing)
  procedure returned_early;
end test_t004_loans_api;
/
create or replace package body test_t004_loans_api as
  procedure setup_data is
  begin
    insert into t004_loans values (1, 10, date '2026-10-01', date '2026-10-04');
    insert into t004_loans values (2, 10, date '2026-10-01', date '2026-10-01');
    insert into t004_loans values (3, 11, date '2026-10-01', date '2026-09-28');
  end setup_data;

  procedure three_days_late is
  begin
    ut.expect(t004_loans_api.late_fee(1)).to_equal(1.5);
  end three_days_late;

  procedure on_time is
  begin
    ut.expect(t004_loans_api.late_fee(2)).to_equal(0);
  end on_time;

  procedure returned_early is
  begin
    ut.expect(t004_loans_api.late_fee(3)).to_equal(0);
  end returned_early;
end test_t004_loans_api;
/
