create or replace view active_staff_v as
-- Staff still employed: no end date yet, or an end date today or later.
select staff_id, full_name, dept_code
  from staff
 where end_date is null
    or end_date >= trunc(sysdate)
/
