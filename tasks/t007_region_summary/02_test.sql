create or replace package test_t007_reports_api as
  --%suite(t007 region summary)

  --%beforeeach
  procedure setup_data;

  --%test(north counts active and VIP customers of the region)
  procedure north;

  --%test(south counts active and VIP customers of the region)
  procedure south;

  --%test(region without customers)
  procedure empty_region;
end test_t007_reports_api;
/
create or replace package body test_t007_reports_api as
  procedure setup_data is
  begin
    insert into t007_customers values (1, 'Asad',   'NORTH', 'ACTIVE',   'N');
    insert into t007_customers values (2, 'Bilal',  'NORTH', 'INACTIVE', 'Y');
    insert into t007_customers values (3, 'Danish', 'NORTH', 'INACTIVE', 'N');
    insert into t007_customers values (4, 'Erum',   'SOUTH', 'ACTIVE',   'N');
    insert into t007_customers values (5, 'Fatima', 'SOUTH', 'INACTIVE', 'Y');
  end setup_data;

  procedure north is
  begin
    ut.expect(t007_reports_api.region_summary('NORTH')).to_equal('NORTH: 2 engaged of 3');
  end north;

  procedure south is
  begin
    ut.expect(t007_reports_api.region_summary('SOUTH')).to_equal('SOUTH: 2 engaged of 2');
  end south;

  procedure empty_region is
  begin
    ut.expect(t007_reports_api.region_summary('EAST')).to_equal('EAST: 0 engaged of 0');
  end empty_region;
end test_t007_reports_api;
/
