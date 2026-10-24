create or replace package freight_config as
  -- Shipping settings. Amounts in the shop currency, weights in kg.
  c_base_fee   constant number := 250;
  c_fee_per_kg constant number := 40;
  c_free_over  constant number := 50000;   -- orders above this amount ship free
end freight_config;
/
create or replace package shipping_cost as
  -- Shipping cost for an order.
  function cost_for(p_order_total in number, p_weight_kg in number) return number;
end shipping_cost;
/
create or replace package body shipping_cost as
  function cost_for(p_order_total in number, p_weight_kg in number) return number is
  begin
    if p_order_total > freight_config.c_free_over then
      return 0;
    end if;
    return freight_config.c_base_fee + ceil(p_weight_kg) * freight_config.c_fee_per_kg;
  end cost_for;
end shipping_cost;
/
