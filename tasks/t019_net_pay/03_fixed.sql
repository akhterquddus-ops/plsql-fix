create or replace package body pension_rules as
  c_rate constant number := 0.05;
  c_cap  constant number := 4000;

  function contribution(p_gross in number) return number is
  begin
    return round(least(p_gross * c_rate, c_cap), 2);
  end contribution;
end pension_rules;
/
