create or replace package test_t003_accounts_api as
  --%suite(t003 account transfers)

  --%beforeeach
  procedure setup_data;

  --%test(small transfer pays the minimum fee)
  procedure small_transfer;

  --%test(normal transfer pays a one percent fee)
  procedure normal_transfer;

  --%test(large transfer fee is capped)
  procedure large_transfer;

  --%test(target account receives the full amount)
  procedure target_credited;
end test_t003_accounts_api;
/
create or replace package body test_t003_accounts_api as
  procedure setup_data is
  begin
    insert into t003_accounts (account_id, balance) values (1,  500);
    insert into t003_accounts (account_id, balance) values (2,  200);
    insert into t003_accounts (account_id, balance) values (3, 5000);
  end setup_data;

  procedure small_transfer is
  begin
    t003_accounts_api.transfer(1, 2, 50);
    ut.expect(t003_accounts_api.balance_of(1)).to_equal(449);
  end small_transfer;

  procedure normal_transfer is
  begin
    t003_accounts_api.transfer(1, 2, 100);
    ut.expect(t003_accounts_api.balance_of(1)).to_equal(399);
  end normal_transfer;

  procedure large_transfer is
  begin
    t003_accounts_api.transfer(3, 2, 2000);
    ut.expect(t003_accounts_api.balance_of(3)).to_equal(2990);
  end large_transfer;

  procedure target_credited is
  begin
    t003_accounts_api.transfer(1, 2, 100);
    ut.expect(t003_accounts_api.balance_of(2)).to_equal(300);
  end target_credited;
end test_t003_accounts_api;
/
