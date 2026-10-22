create or replace package test_t002_working_days as
  --%suite(t002 working days)

  --%test(Monday to Friday of one week is 5 days)
  procedure full_week;

  --%test(a single Monday is 1 day)
  procedure single_day;

  --%test(a weekend has no working days)
  procedure weekend_only;

  --%test(two calendar weeks are 10 days)
  procedure two_weeks;

  --%test(end before start returns 0)
  procedure reversed_range;
end test_t002_working_days;
/
create or replace package body test_t002_working_days as
  procedure full_week is
  begin
    ut.expect(t002_working_days(date '2026-10-19', date '2026-10-23')).to_equal(5);
  end full_week;

  procedure single_day is
  begin
    ut.expect(t002_working_days(date '2026-10-19', date '2026-10-19')).to_equal(1);
  end single_day;

  procedure weekend_only is
  begin
    ut.expect(t002_working_days(date '2026-10-24', date '2026-10-25')).to_equal(0);
  end weekend_only;

  procedure two_weeks is
  begin
    ut.expect(t002_working_days(date '2026-10-19', date '2026-10-30')).to_equal(10);
  end two_weeks;

  procedure reversed_range is
  begin
    ut.expect(t002_working_days(date '2026-10-23', date '2026-10-19')).to_equal(0);
  end reversed_range;
end test_t002_working_days;
/
