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
  end apply_payment;
end t008_invoice_pkg;
/
