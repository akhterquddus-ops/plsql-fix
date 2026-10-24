create or replace trigger shop_orders_au
after update of status on shop_orders
for each row
when (new.status <> old.status)
begin
  -- Keeps a history of every status change of an order.
  insert into order_status_log (order_id, old_status, new_status)
  values (:new.order_id, :new.status, :old.status);
end shop_orders_au;
/
create or replace package order_status_api as
  -- Changes the status of an order.
  procedure set_status(p_order_id in number, p_status in varchar2);
  -- Latest status change of an order as 'OLD->NEW', or NULL if it never changed.
  function last_change(p_order_id in number) return varchar2;
end order_status_api;
/
create or replace package body order_status_api as
  procedure set_status(p_order_id in number, p_status in varchar2) is
  begin
    update shop_orders set status = upper(p_status) where order_id = p_order_id;
  end set_status;

  function last_change(p_order_id in number) return varchar2 is
    l_change varchar2(25);
  begin
    select old_status || '->' || new_status
      into l_change
      from order_status_log
     where order_id = p_order_id
     order by log_id desc
     fetch first 1 row only;
    return l_change;
  exception
    when no_data_found then
      return null;
  end last_change;
end order_status_api;
/
