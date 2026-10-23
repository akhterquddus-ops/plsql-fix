create or replace package test_ticket_api as
  --%suite(t021 ticket due times)

  --%test(urgent ticket is due in 4 hours)
  procedure p1_due;

  --%test(normal ticket is due in 8 hours)
  procedure p2_due;

  --%test(low priority ticket is due in 24 hours)
  procedure p3_due;
end test_ticket_api;
/
create or replace package body test_ticket_api as
  c_opened constant date := to_date('2026-10-01 09:00', 'YYYY-MM-DD HH24:MI');

  procedure p1_due is
  begin
    ut.expect(ticket_api.due_at(c_opened, 'P1'))
      .to_equal(to_date('2026-10-01 13:00', 'YYYY-MM-DD HH24:MI'));
  end p1_due;

  procedure p2_due is
  begin
    ut.expect(ticket_api.due_at(c_opened, 'P2'))
      .to_equal(to_date('2026-10-01 17:00', 'YYYY-MM-DD HH24:MI'));
  end p2_due;

  procedure p3_due is
  begin
    ut.expect(ticket_api.due_at(c_opened, 'P3'))
      .to_equal(to_date('2026-10-02 09:00', 'YYYY-MM-DD HH24:MI'));
  end p3_due;
end test_ticket_api;
/
