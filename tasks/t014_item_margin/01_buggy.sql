create or replace function average_unit_cost(p_sku in varchar2) return number is
  -- Weighted average purchase cost per unit over all goods receipts of an item.
  l_cost number;
begin
  select sum(total_cost) / nullif(count(*), 0)
    into l_cost
    from goods_receipts
   where sku = p_sku;
  return l_cost;
end average_unit_cost;
/
create or replace view item_margins_v as
select i.sku,
       i.list_price,
       average_unit_cost(i.sku) as unit_cost,
       round((i.list_price - average_unit_cost(i.sku)) / i.list_price * 100, 1) as margin_pct
  from catalogue_items i
/
create or replace package margin_report as
  -- Gross margin of an item, in percent of its list price.
  function margin_pct(p_sku in varchar2) return number;
end margin_report;
/
create or replace package body margin_report as
  function margin_pct(p_sku in varchar2) return number is
    l_margin number;
  begin
    select margin_pct into l_margin from item_margins_v where sku = p_sku;
    return l_margin;
  end margin_pct;
end margin_report;
/
