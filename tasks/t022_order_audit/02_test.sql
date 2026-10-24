create or replace package test_order_status_api as
  --%suite(t022 order status history)

  --%beforeeach
  procedure setup_data;

  --%test(one status change)
  procedure one_change;

  --%test(two status changes)
  procedure two_changes;

  --%test(setting the same status logs nothing)
  procedure no_change;
end test_order_status_api;
/
create or replace package body test_order_status_api as
  procedure setup_data is
  begin
    insert into shop_orders values (1, 'Ana', 'NEW');
    insert into shop_orders values (2, 'Bo',  'NEW');
  end setup_data;

  procedure one_change is
  begin
    order_status_api.set_status(1, 'PAID');
    ut.expect(order_status_api.last_change(1)).to_equal('NEW->PAID');
  end one_change;

  procedure two_changes is
  begin
    order_status_api.set_status(1, 'PAID');
    order_status_api.set_status(1, 'SHIPPED');
    ut.expect(order_status_api.last_change(1)).to_equal('PAID->SHIPPED');
  end two_changes;

  procedure no_change is
  begin
    order_status_api.set_status(2, 'NEW');
    ut.expect(order_status_api.last_change(2)).to_be_null();
  end no_change;
end test_order_status_api;
/
