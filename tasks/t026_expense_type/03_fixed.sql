create or replace type body amount_t as
  member function to_base return number is
  begin
    return round(value * rate_to_base, 2);
  end to_base;
end;
/
