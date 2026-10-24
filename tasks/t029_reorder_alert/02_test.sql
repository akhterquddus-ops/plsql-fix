create or replace package test_stock_count_api as
  --%suite(t029 reorder requests)

  --%beforeeach
  procedure setup_data;

  --%test(count equal to reorder point raises a request)
  procedure at_reorder_point;

  --%test(count below reorder point raises a request)
  procedure below_reorder_point;

  --%test(count above reorder point raises nothing)
  procedure above_reorder_point;

  --%test(two counts down to the reorder point raise one request)
  procedure two_counts;
end test_stock_count_api;
/
create or replace package body test_stock_count_api as
  procedure setup_data is
  begin
    insert into inventory_levels values ('A1', 50, 20);
    insert into inventory_levels values ('B2', 50, 20);
    insert into inventory_levels values ('C3', 50, 20);
    insert into inventory_levels values ('D4', 50, 20);
  end setup_data;

  procedure at_reorder_point is
  begin
    stock_count_api.record_count('A1', 20);
    ut.expect(stock_count_api.open_requests('A1')).to_equal(1);
  end at_reorder_point;

  procedure below_reorder_point is
  begin
    stock_count_api.record_count('B2', 10);
    ut.expect(stock_count_api.open_requests('B2')).to_equal(1);
  end below_reorder_point;

  procedure above_reorder_point is
  begin
    stock_count_api.record_count('C3', 30);
    ut.expect(stock_count_api.open_requests('C3')).to_equal(0);
  end above_reorder_point;

  procedure two_counts is
  begin
    stock_count_api.record_count('D4', 25);
    stock_count_api.record_count('D4', 20);
    ut.expect(stock_count_api.open_requests('D4')).to_equal(1);
  end two_counts;
end test_stock_count_api;
/
