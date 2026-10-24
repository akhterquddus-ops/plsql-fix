create or replace package test_expense_api as
  --%suite(t026 expense claims)

  --%beforeeach
  procedure setup_data;

  --%test(claim in USD and GBP)
  procedure mixed_currencies;

  --%test(claim only in EUR)
  procedure base_currency;

  --%test(claim in SEK)
  procedure small_rate;
end test_expense_api;
/
create or replace package body test_expense_api as
  procedure setup_data is
  begin
    insert into expense_lines (claim_id, amount, currency, rate_to_base) values (1,  100, 'USD', 0.92);
    insert into expense_lines (claim_id, amount, currency, rate_to_base) values (1,   50, 'GBP', 1.17);
    insert into expense_lines (claim_id, amount, currency, rate_to_base) values (2,  200, 'EUR', 1);
    insert into expense_lines (claim_id, amount, currency, rate_to_base) values (3, 1000, 'SEK', 0.087);
  end setup_data;

  procedure mixed_currencies is
  begin
    ut.expect(expense_api.claim_total(1)).to_equal(150.5);
  end mixed_currencies;

  procedure base_currency is
  begin
    ut.expect(expense_api.claim_total(2)).to_equal(200);
  end base_currency;

  procedure small_rate is
  begin
    ut.expect(expense_api.claim_total(3)).to_equal(87);
  end small_rate;
end test_expense_api;
/
