create or replace trigger course_enrolments_bi
before insert on course_enrolments
for each row
declare
  l_fee courses.fee%type;
begin
  -- Fee the student pays after their scholarship (a percentage of the course fee).
  select fee into l_fee from courses where course_code = :new.course_code;
  :new.fee_due := round(l_fee * (1 - :new.scholarship_pct / 100), 2);
end course_enrolments_bi;
/
