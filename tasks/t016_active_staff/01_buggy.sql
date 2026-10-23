create or replace view active_staff_v as
-- Staff still employed: no end date yet, or an end date today or later.
select staff_id, full_name, dept_code
  from staff
 where end_date >= trunc(sysdate)
/
create or replace package headcount_report as
  -- Number of people currently employed in a department.
  function headcount(p_dept_code in varchar2) return number;
end headcount_report;
/
create or replace package body headcount_report as
  function headcount(p_dept_code in varchar2) return number is
    l_count number;
  begin
    select count(*) into l_count from active_staff_v where dept_code = p_dept_code;
    return l_count;
  end headcount;
end headcount_report;
/
