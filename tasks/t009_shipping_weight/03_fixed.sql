create or replace package body t009_units as
  function grams_to_kg(p_grams in number) return number is
  begin
    return p_grams / 1000;
  end grams_to_kg;
end t009_units;
/
