create or replace package test_enrolment_api as
  --%suite(t012 enrolment fees)

  --%beforeeach
  procedure setup_data;

  --%test(no scholarship pays the full fee)
  procedure no_scholarship;

  --%test(25 percent scholarship)
  procedure quarter_scholarship;

  --%test(10 percent scholarship on another course)
  procedure tenth_scholarship;
end test_enrolment_api;
/
create or replace package body test_enrolment_api as
  procedure setup_data is
  begin
    insert into courses values ('DB101', 'Databases',   1000);
    insert into courses values ('PY200', 'Python',      1500);
  end setup_data;

  procedure no_scholarship is
  begin
    ut.expect(enrolment_api.enrol(1, 'DB101', 0)).to_equal(1000);
  end no_scholarship;

  procedure quarter_scholarship is
  begin
    ut.expect(enrolment_api.enrol(2, 'DB101', 25)).to_equal(750);
  end quarter_scholarship;

  procedure tenth_scholarship is
  begin
    ut.expect(enrolment_api.enrol(3, 'PY200', 10)).to_equal(1350);
  end tenth_scholarship;
end test_enrolment_api;
/
