create or replace package pension_rules as
  -- Monthly employee pension contribution: 5% of gross pay, at most 4,000.
  function contribution(p_gross in number) return number;
end pension_rules;
/
create or replace package body pension_rules as
  c_rate constant number := 0.05;
  c_cap  constant number := 4000;

  function contribution(p_gross in number) return number is
  begin
    return round(greatest(p_gross * c_rate, c_cap), 2);
  end contribution;
end pension_rules;
/
create or replace package deductions as
  -- All monthly deductions from gross pay: pension plus a 2% income levy.
  function total(p_gross in number) return number;
end deductions;
/
create or replace package body deductions as
  c_levy_rate constant number := 0.02;

  function total(p_gross in number) return number is
  begin
    return pension_rules.contribution(p_gross) + round(p_gross * c_levy_rate, 2);
  end total;
end deductions;
/
create or replace package payroll_api as
  -- Monthly net pay after deductions.
  function net_pay(p_gross in number) return number;
end payroll_api;
/
create or replace package body payroll_api as
  function net_pay(p_gross in number) return number is
  begin
    return p_gross - deductions.total(p_gross);
  end net_pay;
end payroll_api;
/
