create or replace package test_sales_report as
  --%suite(t028 quarterly sales)

  --%beforeeach
  procedure setup_data;

  --%test(first fiscal quarter is July to September)
  procedure first_quarter;

  --%test(second fiscal quarter is October to December)
  procedure second_quarter;

  --%test(fourth fiscal quarter is April to June)
  procedure fourth_quarter;

  --%test(region without sales)
  procedure empty_region;
end test_sales_report;
/
create or replace package body test_sales_report as
  procedure setup_data is
  begin
    insert into sales values (1, 'NORTH', date '2025-07-15', 100);
    insert into sales values (2, 'NORTH', date '2025-09-30',  50);
    insert into sales values (3, 'NORTH', date '2025-10-01',  70);
    insert into sales values (4, 'NORTH', date '2026-04-10',  30);
  end setup_data;

  procedure first_quarter is
  begin
    ut.expect(sales_report.quarter_total('NORTH', 2026, 1)).to_equal(150);
  end first_quarter;

  procedure second_quarter is
  begin
    ut.expect(sales_report.quarter_total('NORTH', 2026, 2)).to_equal(70);
  end second_quarter;

  procedure fourth_quarter is
  begin
    ut.expect(sales_report.quarter_total('NORTH', 2026, 4)).to_equal(30);
  end fourth_quarter;

  procedure empty_region is
  begin
    ut.expect(sales_report.quarter_total('SOUTH', 2026, 1)).to_equal(0);
  end empty_region;
end test_sales_report;
/
