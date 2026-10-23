create or replace trigger course_enrolments_bi
before insert on course_enrolments
for each row
declare
  l_fee courses.fee%type;
begin
  -- Fee the student pays after their scholarship (a percentage of the course fee).
  select fee into l_fee from courses where course_code = :new.course_code;
  :new.fee_due := l_fee - :new.scholarship_pct;
end course_enrolments_bi;
/
create or replace package enrolment_api as
  -- Enrols a student on a course and returns the fee they have to pay.
  function enrol(p_student_id      in number,
                 p_course_code     in varchar2,
                 p_scholarship_pct in number default 0) return number;
end enrolment_api;
/
create or replace package body enrolment_api as
  function enrol(p_student_id      in number,
                 p_course_code     in varchar2,
                 p_scholarship_pct in number default 0) return number is
    l_fee_due course_enrolments.fee_due%type;
  begin
    insert into course_enrolments (student_id, course_code, scholarship_pct)
    values (p_student_id, p_course_code, nvl(p_scholarship_pct, 0))
    returning fee_due into l_fee_due;
    return l_fee_due;
  end enrol;
end enrolment_api;
/
