create or replace package test_margin_report as
  --%suite(t014 item margins)

  --%beforeeach
  procedure setup_data;

  --%test(item bought in two deliveries)
  procedure two_deliveries;

  --%test(item bought in one delivery)
  procedure one_delivery;

  --%test(cheap item bought in bulk twice)
  procedure bulk_item;
end test_margin_report;
/
create or replace package body test_margin_report as
  procedure setup_data is
  begin
    insert into catalogue_items values ('LAMP-1', 'Desk lamp', 100);
    insert into catalogue_items values ('DESK-2', 'Desk',      250);
    insert into catalogue_items values ('PEN-3',  'Pen',         2);
    insert into goods_receipts (sku, qty, total_cost) values ('LAMP-1',  10,  500);
    insert into goods_receipts (sku, qty, total_cost) values ('LAMP-1',  30, 1800);
    insert into goods_receipts (sku, qty, total_cost) values ('DESK-2',   1,  150);
    insert into goods_receipts (sku, qty, total_cost) values ('PEN-3',  100,   80);
    insert into goods_receipts (sku, qty, total_cost) values ('PEN-3',  100,   80);
  end setup_data;

  procedure two_deliveries is
  begin
    ut.expect(margin_report.margin_pct('LAMP-1')).to_equal(42.5);
  end two_deliveries;

  procedure one_delivery is
  begin
    ut.expect(margin_report.margin_pct('DESK-2')).to_equal(40);
  end one_delivery;

  procedure bulk_item is
  begin
    ut.expect(margin_report.margin_pct('PEN-3')).to_equal(60);
  end bulk_item;
end test_margin_report;
/
