create or replace package freight_config as
  -- Shipping settings. Amounts in the shop currency, weights in kg.
  c_base_fee   constant number := 250;
  c_fee_per_kg constant number := 40;
  c_free_over  constant number := 5000;   -- orders above this amount ship free
end freight_config;
/
