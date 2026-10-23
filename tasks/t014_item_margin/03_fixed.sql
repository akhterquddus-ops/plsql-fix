create or replace function average_unit_cost(p_sku in varchar2) return number is
  -- Weighted average purchase cost per unit over all goods receipts of an item.
  l_cost number;
begin
  select sum(total_cost) / nullif(sum(qty), 0)
    into l_cost
    from goods_receipts
   where sku = p_sku;
  return l_cost;
end average_unit_cost;
/
