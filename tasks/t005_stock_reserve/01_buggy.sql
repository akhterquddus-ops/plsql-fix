create or replace package t005_stock_util as
  -- Units of a product that can still be reserved (on hand minus reserved).
  function available(p_product_id in number) return number;
end t005_stock_util;
/
create or replace package body t005_stock_util as
  function available(p_product_id in number) return number is
    l_available number;
  begin
    select on_hand - reserved
      into l_available
      from t005_stock
     where product_id = p_product_id;
    return l_available;
  exception
    when no_data_found then
      return 0;
  end available;
end t005_stock_util;
/
create or replace package t005_stock_pkg as
  function can_reserve(p_product_id in number, p_qty in number) return boolean;
  procedure reserve(p_product_id in number, p_qty in number);
end t005_stock_pkg;
/
create or replace package body t005_stock_pkg as
  function can_reserve(p_product_id in number, p_qty in number) return boolean is
  begin
    return t005_stock_util.available(p_product_id) >= p_qty;
  end can_reserve;

  procedure reserve(p_product_id in number, p_qty in number) is
  begin
    update t005_stock
       set reserved = nvl(reserved, 0) + p_qty
     where product_id = p_product_id;
  end reserve;
end t005_stock_pkg;
/
create or replace package t005_orders_api as
  -- Reserves stock for an order line. Returns OK, NO_STOCK or INVALID.
  function place_order(p_product_id in number, p_qty in number) return varchar2;
end t005_orders_api;
/
create or replace package body t005_orders_api as
  function place_order(p_product_id in number, p_qty in number) return varchar2 is
  begin
    if p_qty is null or p_qty <= 0 then
      return 'INVALID';
    end if;
    if t005_stock_pkg.can_reserve(p_product_id, p_qty) then
      t005_stock_pkg.reserve(p_product_id, p_qty);
      return 'OK';
    end if;
    return 'NO_STOCK';
  end place_order;
end t005_orders_api;
/
