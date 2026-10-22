create or replace package body t001_pricing as
  function line_amount(
    p_qty          in number,
    p_unit_price   in number,
    p_discount_pct in number default 0
  ) return number is
  begin
    return round(p_qty * p_unit_price * (1 - nvl(p_discount_pct, 0) / 100), 2);
  end line_amount;
end t001_pricing;
/
