create or replace package test_pricing_quote as
  --%suite(t023 tier discounts)

  --%beforeeach
  procedure setup_data;

  --%test(spend of exactly 1000 is silver)
  procedure exactly_silver;

  --%test(spend of exactly 5000 is gold)
  procedure exactly_gold;

  --%test(spend between tiers)
  procedure between_tiers;
end test_pricing_quote;
/
create or replace package body test_pricing_quote as
  procedure setup_data is
  begin
    insert into discount_tiers values ('BRONZE',    0,  0);
    insert into discount_tiers values ('SILVER', 1000,  5);
    insert into discount_tiers values ('GOLD',   5000, 10);
    insert into shop_customers values (1, 'Ana', 1000);
    insert into shop_customers values (2, 'Bo',  5000);
    insert into shop_customers values (3, 'Cy',  2500);
  end setup_data;

  procedure exactly_silver is
  begin
    ut.expect(pricing_quote.quote(1, 200)).to_equal(190);
  end exactly_silver;

  procedure exactly_gold is
  begin
    ut.expect(pricing_quote.quote(2, 200)).to_equal(180);
  end exactly_gold;

  procedure between_tiers is
  begin
    ut.expect(pricing_quote.quote(3, 200)).to_equal(190);
  end between_tiers;
end test_pricing_quote;
/
