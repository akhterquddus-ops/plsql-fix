drop table if exists course_enrolments purge
/
drop table if exists courses purge
/
create table courses (
  course_code varchar2(10) primary key,
  title       varchar2(60) not null,
  fee         number(10,2) not null
)
/
create table course_enrolments (
  enrolment_id    number generated always as identity primary key,
  student_id      number not null,
  course_code     varchar2(10) not null references courses (course_code),
  scholarship_pct number(5,2) default 0 not null,
  fee_due         number(10,2)
)
/
