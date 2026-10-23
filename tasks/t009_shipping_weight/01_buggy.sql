create or replace package t009_units as
  function grams_to_kg(p_grams in number) return number;
end t009_units;
/
create or replace package body t009_units as
  function grams_to_kg(p_grams in number) return number is
  begin
    return p_grams / 100;
  end grams_to_kg;
end t009_units;
/
create or replace package t009_parcel_pkg as
  -- Total parcel weight of an order in kilograms.
  function parcel_weight_kg(p_order_id in number) return number;
end t009_parcel_pkg;
/
create or replace package body t009_parcel_pkg as
  function parcel_weight_kg(p_order_id in number) return number is
    l_grams number;
  begin
    select nvl(sum(weight_g * qty), 0)
      into l_grams
      from t009_order_items
     where order_id = p_order_id;
    return t009_units.grams_to_kg(l_grams);
  end parcel_weight_kg;
end t009_parcel_pkg;
/
create or replace package t009_shipping_pkg as
  -- 200 base charge plus 50 per started kilogram; free if nothing is shipped.
  function shipping_cost(p_order_id in number) return number;
end t009_shipping_pkg;
/
create or replace package body t009_shipping_pkg as
  c_base   constant number := 200;
  c_per_kg constant number := 50;

  function shipping_cost(p_order_id in number) return number is
    l_kg number := t009_parcel_pkg.parcel_weight_kg(p_order_id);
  begin
    if l_kg = 0 then
      return 0;
    end if;
    return c_base + c_per_kg * ceil(l_kg);
  end shipping_cost;
end t009_shipping_pkg;
/
create or replace package t009_checkout_api as
  -- Amount to pay: item total plus shipping.
  function order_total(p_order_id in number) return number;
end t009_checkout_api;
/
create or replace package body t009_checkout_api as
  function order_total(p_order_id in number) return number is
    l_items number;
  begin
    select nvl(sum(price * qty), 0)
      into l_items
      from t009_order_items
     where order_id = p_order_id;
    return l_items + t009_shipping_pkg.shipping_cost(p_order_id);
  end order_total;
end t009_checkout_api;
/
