create or replace view customer_tiers_v as
-- Loyalty tier of each customer: the highest tier whose minimum spend the customer has reached.
select c.customer_id, t.tier_name, t.discount_pct
  from shop_customers c, discount_tiers t
 where t.min_spend = (select max(t2.min_spend)
                        from discount_tiers t2
                       where t2.min_spend < c.annual_spend)
/
create or replace package pricing_quote as
  -- Price after the customer's loyalty tier discount.
  function quote(p_customer_id in number, p_amount in number) return number;
end pricing_quote;
/
create or replace package body pricing_quote as
  function quote(p_customer_id in number, p_amount in number) return number is
    l_pct customer_tiers_v.discount_pct%type;
  begin
    begin
      select discount_pct into l_pct from customer_tiers_v where customer_id = p_customer_id;
    exception
      when no_data_found then
        l_pct := 0;
    end;
    return round(p_amount * (1 - l_pct / 100), 2);
  end quote;
end pricing_quote;
/
