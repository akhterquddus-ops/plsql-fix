create or replace package test_warehouse_api as
  --%suite(t013 warehouse stock)

  --%beforeeach
  procedure setup_data;

  --%test(receiving adds to the bin)
  procedure receive_adds;

  --%test(shipping takes from the bin)
  procedure ship_takes;

  --%test(shipping everything empties the bin)
  procedure ship_all;
end test_warehouse_api;
/
create or replace package body test_warehouse_api as
  procedure setup_data is
  begin
    insert into warehouse_bins values ('A1', 'BOLT-M6', 10);
  end setup_data;

  procedure receive_adds is
  begin
    warehouse_api.receive('A1', 5);
    ut.expect(warehouse_api.on_hand('A1')).to_equal(15);
  end receive_adds;

  procedure ship_takes is
  begin
    warehouse_api.ship('A1', 4);
    ut.expect(warehouse_api.on_hand('A1')).to_equal(6);
  end ship_takes;

  procedure ship_all is
  begin
    warehouse_api.ship('A1', 10);
    ut.expect(warehouse_api.on_hand('A1')).to_equal(0);
  end ship_all;
end test_warehouse_api;
/
