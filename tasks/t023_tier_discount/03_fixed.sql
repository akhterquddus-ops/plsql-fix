create or replace view customer_tiers_v as
-- Loyalty tier of each customer: the highest tier whose minimum spend the customer has reached.
select c.customer_id, t.tier_name, t.discount_pct
  from shop_customers c, discount_tiers t
 where t.min_spend = (select max(t2.min_spend)
                        from discount_tiers t2
                       where t2.min_spend <= c.annual_spend)
/
