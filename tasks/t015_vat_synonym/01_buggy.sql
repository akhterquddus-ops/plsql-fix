create or replace package vat_rates_2025 as
  -- VAT rates in percent, valid until 31 December 2025.
  function rate_for(p_region in varchar2) return number;
end vat_rates_2025;
/
create or replace package body vat_rates_2025 as
  function rate_for(p_region in varchar2) return number is
  begin
    return case p_region
             when 'NORTH' then 16
             when 'SOUTH' then 13
             else 15
           end;
  end rate_for;
end vat_rates_2025;
/
create or replace package vat_rates_2026 as
  -- VAT rates in percent, valid from 1 January 2026.
  function rate_for(p_region in varchar2) return number;
end vat_rates_2026;
/
create or replace package body vat_rates_2026 as
  function rate_for(p_region in varchar2) return number is
  begin
    return case p_region
             when 'NORTH' then 18
             when 'SOUTH' then 15
             else 17
           end;
  end rate_for;
end vat_rates_2026;
/
create or replace synonym vat_rates for vat_rates_2025
/
create or replace package invoice_tax as
  -- VAT for an invoice line, using the current VAT rates.
  function vat_for(p_amount in number, p_region in varchar2) return number;
end invoice_tax;
/
create or replace package body invoice_tax as
  function vat_for(p_amount in number, p_region in varchar2) return number is
  begin
    return round(p_amount * vat_rates.rate_for(p_region) / 100, 2);
  end vat_for;
end invoice_tax;
/
