create or replace package test_atm_api as
  --%suite(t017 cash withdrawals)

  --%beforeeach
  procedure setup_data;

  --%test(withdrawal within the overdraft limit is allowed)
  procedure within_limit;

  --%test(withdrawal beyond the overdraft limit is declined)
  procedure beyond_limit;

  --%test(declined withdrawal leaves the balance unchanged)
  procedure declined_no_change;
end test_atm_api;
/
create or replace package body test_atm_api as
  procedure setup_data is
  begin
    insert into bank_accounts values ('A1', 'Hamza', 100, 50);
  end setup_data;

  procedure within_limit is
  begin
    ut.expect(atm_api.withdraw('A1', 120)).to_equal('OK');
  end within_limit;

  procedure beyond_limit is
  begin
    ut.expect(atm_api.withdraw('A1', 200)).to_equal('DECLINED');
  end beyond_limit;

  procedure declined_no_change is
    l_status varchar2(10);
  begin
    l_status := atm_api.withdraw('A1', 200);
    ut.expect(atm_api.balance_of('A1')).to_equal(100);
  end declined_no_change;
end test_atm_api;
/
