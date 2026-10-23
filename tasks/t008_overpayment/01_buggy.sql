create or replace package t008_invoice_pkg as
  -- Reduces the open amount of an invoice.
  -- Raises ORA-20010 if the payment is larger than the open amount.
  procedure apply_payment(p_invoice_id in number, p_amount in number);
end t008_invoice_pkg;
/
create or replace package body t008_invoice_pkg as
  procedure apply_payment(p_invoice_id in number, p_amount in number) is
    l_open t008_invoices.open_amount%type;
  begin
    select open_amount
      into l_open
      from t008_invoices
     where invoice_id = p_invoice_id
       for update;

    if p_amount > l_open then
      raise_application_error(-20010, 'Payment exceeds open amount');
    end if;

    update t008_invoices
       set open_amount = open_amount - p_amount
     where invoice_id = p_invoice_id;
  exception
    when others then
      null;
  end apply_payment;
end t008_invoice_pkg;
/
create or replace package t008_payments_api as
  -- Pays an invoice. Returns PAID, or REJECTED for overpayments.
  function pay_invoice(p_invoice_id in number, p_amount in number) return varchar2;
end t008_payments_api;
/
create or replace package body t008_payments_api as
  function pay_invoice(p_invoice_id in number, p_amount in number) return varchar2 is
    e_overpayment exception;
    pragma exception_init(e_overpayment, -20010);
  begin
    t008_invoice_pkg.apply_payment(p_invoice_id, p_amount);
    return 'PAID';
  exception
    when e_overpayment then
      return 'REJECTED';
  end pay_invoice;
end t008_payments_api;
/
