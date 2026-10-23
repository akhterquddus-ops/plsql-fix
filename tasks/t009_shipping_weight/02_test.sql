create or replace package test_t009_checkout_api as
  --%suite(t009 checkout totals)

  --%beforeeach
  procedure setup_data;

  --%test(two items of 750 g ship as 2 kg)
  procedure two_items;

  --%test(a single light item ships as 1 kg)
  procedure light_item;

  --%test(digital items ship for free)
  procedure digital_only;
end test_t009_checkout_api;
/
create or replace package body test_t009_checkout_api as
  procedure setup_data is
  begin
    insert into t009_order_items values (1, 1, 500.00, 750, 2);
    insert into t009_order_items values (2, 1, 250.00, 400, 1);
    insert into t009_order_items values (3, 1,  99.00,   0, 1);
  end setup_data;

  procedure two_items is
  begin
    ut.expect(t009_checkout_api.order_total(1)).to_equal(1300);
  end two_items;

  procedure light_item is
  begin
    ut.expect(t009_checkout_api.order_total(2)).to_equal(500);
  end light_item;

  procedure digital_only is
  begin
    ut.expect(t009_checkout_api.order_total(3)).to_equal(99);
  end digital_only;
end test_t009_checkout_api;
/
