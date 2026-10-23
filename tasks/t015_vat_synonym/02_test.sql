create or replace package test_invoice_tax as
  --%suite(t015 invoice VAT)

  --%test(north region)
  procedure north;

  --%test(south region)
  procedure south;

  --%test(other regions)
  procedure other_region;
end test_invoice_tax;
/
create or replace package body test_invoice_tax as
  procedure north is
  begin
    ut.expect(invoice_tax.vat_for(1000, 'NORTH')).to_equal(180);
  end north;

  procedure south is
  begin
    ut.expect(invoice_tax.vat_for(1000, 'SOUTH')).to_equal(150);
  end south;

  procedure other_region is
  begin
    ut.expect(invoice_tax.vat_for(1000, 'EAST')).to_equal(170);
  end other_region;
end test_invoice_tax;
/
