create or replace package test_t008_payments_api as
  --%suite(t008 invoice payments)

  --%beforeeach
  procedure setup_data;

  --%test(normal payment is accepted)
  procedure normal_payment;

  --%test(normal payment reduces the open amount)
  procedure open_amount_reduced;

  --%test(overpayment is rejected)
  procedure overpayment_rejected;

  --%test(overpayment leaves the open amount unchanged)
  procedure overpayment_no_change;
end test_t008_payments_api;
/
create or replace package body test_t008_payments_api as
  function open_amount(p_invoice_id in number) return number is
    l_open number;
  begin
    select open_amount into l_open from t008_invoices where invoice_id = p_invoice_id;
    return l_open;
  end open_amount;

  procedure setup_data is
  begin
    insert into t008_invoices values (1, 100, 300);
  end setup_data;

  procedure normal_payment is
  begin
    ut.expect(t008_payments_api.pay_invoice(1, 100)).to_equal('PAID');
  end normal_payment;

  procedure open_amount_reduced is
    l_status varchar2(10);
  begin
    l_status := t008_payments_api.pay_invoice(1, 100);
    ut.expect(open_amount(1)).to_equal(200);
  end open_amount_reduced;

  procedure overpayment_rejected is
  begin
    ut.expect(t008_payments_api.pay_invoice(1, 500)).to_equal('REJECTED');
  end overpayment_rejected;

  procedure overpayment_no_change is
    l_status varchar2(10);
  begin
    l_status := t008_payments_api.pay_invoice(1, 500);
    ut.expect(open_amount(1)).to_equal(300);
  end overpayment_no_change;
end test_t008_payments_api;
/
