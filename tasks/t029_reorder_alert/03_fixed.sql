create or replace package body reorder_rules as
  function needs_reorder(p_on_hand in number, p_reorder_point in number) return boolean is
  begin
    return p_on_hand <= p_reorder_point;
  end needs_reorder;
end reorder_rules;
/
