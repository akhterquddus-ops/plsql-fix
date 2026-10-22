create or replace package body t003_fees as
  c_rate    constant number := 0.01;
  c_min_fee constant number := 1;
  c_max_fee constant number := 10;

  function fee_for(p_amount in number) return number is
  begin
    return least(greatest(round(p_amount * c_rate, 2), c_min_fee), c_max_fee);
  end fee_for;
end t003_fees;
/
