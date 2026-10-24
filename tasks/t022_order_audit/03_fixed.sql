create or replace trigger shop_orders_au
after update of status on shop_orders
for each row
when (new.status <> old.status)
begin
  -- Keeps a history of every status change of an order.
  insert into order_status_log (order_id, old_status, new_status)
  values (:new.order_id, :old.status, :new.status);
end shop_orders_au;
/
