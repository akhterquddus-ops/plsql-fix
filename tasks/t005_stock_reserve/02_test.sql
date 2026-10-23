create or replace package test_t005_orders_api as
  --%suite(t005 stock reservation)

  --%beforeeach
  procedure setup_data;

  --%test(order within available stock is accepted)
  procedure order_ok;

  --%test(product without earlier reservations can be ordered)
  procedure order_never_reserved;

  --%test(order above available stock is refused)
  procedure order_no_stock;

  --%test(accepted order increases the reserved quantity)
  procedure reservation_recorded;
end test_t005_orders_api;
/
create or replace package body test_t005_orders_api as
  procedure setup_data is
  begin
    insert into t005_stock values (1, 10, 2);
    insert into t005_stock values (2, 10, null);
    insert into t005_stock values (3,  3, 0);
  end setup_data;

  procedure order_ok is
  begin
    ut.expect(t005_orders_api.place_order(1, 5)).to_equal('OK');
  end order_ok;

  procedure order_never_reserved is
  begin
    ut.expect(t005_orders_api.place_order(2, 5)).to_equal('OK');
  end order_never_reserved;

  procedure order_no_stock is
  begin
    ut.expect(t005_orders_api.place_order(3, 5)).to_equal('NO_STOCK');
  end order_no_stock;

  procedure reservation_recorded is
    l_status   varchar2(10);
    l_reserved number;
  begin
    l_status := t005_orders_api.place_order(1, 5);
    select reserved into l_reserved from t005_stock where product_id = 1;
    ut.expect(l_reserved).to_equal(7);
  end reservation_recorded;
end test_t005_orders_api;
/
