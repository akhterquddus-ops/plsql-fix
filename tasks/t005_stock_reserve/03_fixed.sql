create or replace package body t005_stock_util as
  function available(p_product_id in number) return number is
    l_available number;
  begin
    select on_hand - nvl(reserved, 0)
      into l_available
      from t005_stock
     where product_id = p_product_id;
    return l_available;
  exception
    when no_data_found then
      return 0;
  end available;
end t005_stock_util;
/
