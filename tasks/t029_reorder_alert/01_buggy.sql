create or replace package reorder_rules as
  -- An item is reordered when its stock falls to or below its reorder point.
  function needs_reorder(p_on_hand in number, p_reorder_point in number) return boolean;
end reorder_rules;
/
create or replace package body reorder_rules as
  function needs_reorder(p_on_hand in number, p_reorder_point in number) return boolean is
  begin
    return p_on_hand < p_reorder_point;
  end needs_reorder;
end reorder_rules;
/
create or replace trigger inventory_levels_au
after update of on_hand on inventory_levels
for each row
begin
  -- Raises one reorder request when an item crosses into the reorder zone.
  if reorder_rules.needs_reorder(:new.on_hand, :new.reorder_point)
     and not reorder_rules.needs_reorder(:old.on_hand, :old.reorder_point) then
    insert into reorder_requests (sku) values (:new.sku);
  end if;
end inventory_levels_au;
/
create or replace package stock_count_api as
  -- Records the result of a stock count.
  procedure record_count(p_sku in varchar2, p_counted in number);
  -- Number of reorder requests raised for an item.
  function open_requests(p_sku in varchar2) return number;
end stock_count_api;
/
create or replace package body stock_count_api as
  procedure record_count(p_sku in varchar2, p_counted in number) is
  begin
    update inventory_levels set on_hand = p_counted where sku = p_sku;
  end record_count;

  function open_requests(p_sku in varchar2) return number is
    l_count number;
  begin
    select count(*) into l_count from reorder_requests where sku = p_sku;
    return l_count;
  end open_requests;
end stock_count_api;
/
