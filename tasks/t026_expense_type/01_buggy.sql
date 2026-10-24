create or replace type amount_t as object (
  value        number,
  rate_to_base number,
  -- The amount in the base currency (rate_to_base = base currency per one unit).
  member function to_base return number
);
/
create or replace type body amount_t as
  member function to_base return number is
  begin
    return round(value / rate_to_base, 2);
  end to_base;
end;
/
create or replace package expense_api as
  -- Total of an expense claim in the base currency (EUR).
  function claim_total(p_claim_id in number) return number;
end expense_api;
/
create or replace package body expense_api as
  function claim_total(p_claim_id in number) return number is
    l_total number := 0;
  begin
    for l in (select amount, rate_to_base from expense_lines where claim_id = p_claim_id) loop
      l_total := l_total + amount_t(l.amount, l.rate_to_base).to_base();
    end loop;
    return l_total;
  end claim_total;
end expense_api;
/
