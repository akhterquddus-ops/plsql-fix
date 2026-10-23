create or replace trigger stock_moves_ai
after insert on stock_moves
for each row
begin
  update warehouse_bins
     set qty = qty + case :new.direction when 'IN' then :new.qty else -:new.qty end
   where bin_code = :new.bin_code;
end stock_moves_ai;
/
