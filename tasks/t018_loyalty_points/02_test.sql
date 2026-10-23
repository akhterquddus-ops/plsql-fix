create or replace package test_loyalty_api as
  --%suite(t018 loyalty points)

  --%beforeeach
  procedure setup_data;

  --%test(purchase of 250 earns 2 points)
  procedure purchase_250;

  --%test(purchase below 100 earns nothing)
  procedure purchase_99;

  --%test(purchase of 1000 earns 10 points)
  procedure purchase_1000;
end test_loyalty_api;
/
create or replace package body test_loyalty_api as
  procedure setup_data is
  begin
    insert into loyalty_members values (1, 'Sana',  0);
    insert into loyalty_members values (2, 'Omar', 10);
  end setup_data;

  procedure purchase_250 is
  begin
    ut.expect(loyalty_api.add_purchase(1, 250)).to_equal(2);
  end purchase_250;

  procedure purchase_99 is
  begin
    ut.expect(loyalty_api.add_purchase(2, 99)).to_equal(10);
  end purchase_99;

  procedure purchase_1000 is
  begin
    ut.expect(loyalty_api.add_purchase(1, 1000)).to_equal(10);
  end purchase_1000;
end test_loyalty_api;
/
