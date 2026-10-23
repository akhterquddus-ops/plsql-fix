create or replace package points_rules as
  -- Loyalty points earned on a purchase: 1 point per full 100 spent.
  function points_for(p_amount in number) return number;
end points_rules;
/
create or replace package body points_rules as
  function points_for(p_amount in number) return number is
  begin
    return floor(nvl(p_amount, 0) / 10);
  end points_for;
end points_rules;
/
create or replace trigger loyalty_purchases_ai
after insert on loyalty_purchases
for each row
begin
  update loyalty_members
     set points = points + points_rules.points_for(:new.amount)
   where member_id = :new.member_id;
end loyalty_purchases_ai;
/
create or replace package loyalty_api as
  -- Records a purchase for a member and returns the member's new points balance.
  function add_purchase(p_member_id in number, p_amount in number) return number;
end loyalty_api;
/
create or replace package body loyalty_api as
  function add_purchase(p_member_id in number, p_amount in number) return number is
    l_points loyalty_members.points%type;
  begin
    insert into loyalty_purchases (member_id, amount) values (p_member_id, p_amount);
    select points into l_points from loyalty_members where member_id = p_member_id;
    return l_points;
  end add_purchase;
end loyalty_api;
/
