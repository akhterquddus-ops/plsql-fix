create or replace package test_t001_orders_api as
  --%suite(t001 order totals)

  --%beforeeach
  procedure setup_data;

  --%test(order without discounts sums all lines)
  procedure total_without_discount;

  --%test(order with a 10 percent line discount)
  procedure total_with_discount;

  --%test(order with no lines totals zero)
  procedure total_empty_order;
end test_t001_orders_api;
/
create or replace package body test_t001_orders_api as
  procedure setup_data is
  begin
    insert into t001_orders (order_id, customer_id) values (1, 100);
    insert into t001_orders (order_id, customer_id) values (2, 100);
    insert into t001_orders (order_id, customer_id) values (3, 200);
    insert into t001_order_lines values (1, 1, 'PEN',    10,   2.50,  0);
    insert into t001_order_lines values (1, 2, 'BOOK',    2,  15.00,  0);
    insert into t001_order_lines values (2, 1, 'CHAIR',   1, 120.00, 10);
    insert into t001_order_lines values (2, 2, 'LAMP',    2,  40.00,  0);
  end setup_data;

  procedure total_without_discount is
  begin
    ut.expect(t001_orders_api.order_total(1)).to_equal(55);
  end total_without_discount;

  procedure total_with_discount is
  begin
    ut.expect(t001_orders_api.order_total(2)).to_equal(188);
  end total_with_discount;

  procedure total_empty_order is
  begin
    ut.expect(t001_orders_api.order_total(3)).to_equal(0);
  end total_empty_order;
end test_t001_orders_api;
/
