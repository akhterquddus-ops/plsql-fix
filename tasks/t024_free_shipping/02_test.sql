create or replace package test_shipping_cost as
  --%suite(t024 shipping cost)

  --%test(order of 6000 ships free)
  procedure free_6000;

  --%test(order of 10000 ships free)
  procedure free_10000;

  --%test(small order pays base fee plus weight)
  procedure small_order;
end test_shipping_cost;
/
create or replace package body test_shipping_cost as
  procedure free_6000 is
  begin
    ut.expect(shipping_cost.cost_for(6000, 2)).to_equal(0);
  end free_6000;

  procedure free_10000 is
  begin
    ut.expect(shipping_cost.cost_for(10000, 5)).to_equal(0);
  end free_10000;

  procedure small_order is
  begin
    ut.expect(shipping_cost.cost_for(3000, 1.5)).to_equal(330);
  end small_order;
end test_shipping_cost;
/
