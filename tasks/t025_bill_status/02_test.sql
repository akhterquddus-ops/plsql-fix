create or replace package test_billing_api as
  --%suite(t025 bill status)

  --%beforeeach
  procedure setup_data;

  --%test(paid in one payment)
  procedure paid_once;

  --%test(paid in two payments)
  procedure paid_twice;

  --%test(part payment)
  procedure part_paid;
end test_billing_api;
/
create or replace package body test_billing_api as
  function status_of(p_bill_id in number) return varchar2 is
    l_status bills.status%type;
  begin
    select status into l_status from bills where bill_id = p_bill_id;
    return l_status;
  end status_of;

  procedure setup_data is
  begin
    insert into bills (bill_id, customer, amount) values (1, 'Ana', 100);
    insert into bills (bill_id, customer, amount) values (2, 'Bo',  100);
    insert into bills (bill_id, customer, amount) values (3, 'Cy',  100);
  end setup_data;

  procedure paid_once is
  begin
    billing_api.pay(1, 100);
    ut.expect(status_of(1)).to_equal('PAID');
  end paid_once;

  procedure paid_twice is
  begin
    billing_api.pay(2, 40);
    billing_api.pay(2, 60);
    ut.expect(status_of(2)).to_equal('PAID');
  end paid_twice;

  procedure part_paid is
  begin
    billing_api.pay(3, 40);
    ut.expect(status_of(3)).to_equal('PARTIAL');
  end part_paid;
end test_billing_api;
/
