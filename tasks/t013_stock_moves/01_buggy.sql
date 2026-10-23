create or replace trigger stock_moves_ai
after insert on stock_moves
for each row
begin
  update warehouse_bins
     set qty = qty + :new.qty
   where bin_code = :new.bin_code;
end stock_moves_ai;
/
create or replace package warehouse_api as
  -- Records goods received into a bin.
  procedure receive(p_bin_code in varchar2, p_qty in number);
  -- Records goods shipped out of a bin. Raises ORA-20060 if the bin holds too little.
  procedure ship(p_bin_code in varchar2, p_qty in number);
  function on_hand(p_bin_code in varchar2) return number;
end warehouse_api;
/
create or replace package body warehouse_api as
  function on_hand(p_bin_code in varchar2) return number is
    l_qty warehouse_bins.qty%type;
  begin
    select qty into l_qty from warehouse_bins where bin_code = p_bin_code;
    return l_qty;
  end on_hand;

  procedure receive(p_bin_code in varchar2, p_qty in number) is
  begin
    insert into stock_moves (bin_code, direction, qty) values (p_bin_code, 'IN', p_qty);
  end receive;

  procedure ship(p_bin_code in varchar2, p_qty in number) is
  begin
    if on_hand(p_bin_code) < p_qty then
      raise_application_error(-20060, 'Not enough stock in bin ' || p_bin_code);
    end if;
    insert into stock_moves (bin_code, direction, qty) values (p_bin_code, 'OUT', p_qty);
  end ship;
end warehouse_api;
/
