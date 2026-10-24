create or replace trigger employee_directory_ioi
instead of insert on employee_directory_v
for each row
begin
  -- New people are added through the directory view.
  insert into hr_people (person_id, full_name) values (:new.person_id, :new.full_name);
  insert into hr_contacts (person_id, email, phone) values (:new.person_id, :new.email, :new.phone);
end employee_directory_ioi;
/
