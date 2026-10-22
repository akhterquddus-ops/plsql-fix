create or replace package t001_pricing as
  -- Amount for one order line after the line discount, rounded to cents.
  function line_amount(
    p_qty          in number,
    p_unit_price   in number,
    p_discount_pct in number default 0
  ) return number;
end t001_pricing;
/
create or replace package body t001_pricing as
  function line_amount(
    p_qty          in number,
    p_unit_price   in number,
    p_discount_pct in number default 0
  ) return number is
  begin
    return round(p_qty * p_unit_price * (1 - nvl(p_discount_pct, 0)), 2);
  end line_amount;
end t001_pricing;
/
create or replace package t001_orders_api as
  -- Total amount of an order: the sum of its line amounts.
  function order_total(p_order_id in number) return number;
end t001_orders_api;
/
create or replace package body t001_orders_api as
  function order_total(p_order_id in number) return number is
    l_total number := 0;
  begin
    for r in (select qty, unit_price, discount_pct
                from t001_order_lines
               where order_id = p_order_id) loop
      l_total := l_total + t001_pricing.line_amount(r.qty, r.unit_price, r.discount_pct);
    end loop;
    return l_total;
  end order_total;
end t001_orders_api;
/
