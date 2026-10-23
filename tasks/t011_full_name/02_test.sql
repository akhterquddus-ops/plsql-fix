create or replace package test_t011_full_name as
  --%suite(t011 full name)

  --%test(first, middle and last name)
  procedure all_parts;

  --%test(no middle name)
  procedure no_middle;

  --%test(last name only)
  procedure last_only;
end test_t011_full_name;
/
create or replace package body test_t011_full_name as
  procedure all_parts is
  begin
    ut.expect(t011_full_name('Ali', 'Raza', 'Khan')).to_equal('Ali Raza Khan');
  end all_parts;

  procedure no_middle is
  begin
    ut.expect(t011_full_name('Sara', null, 'Ahmed')).to_equal('Sara Ahmed');
  end no_middle;

  procedure last_only is
  begin
    ut.expect(t011_full_name(null, null, 'Khan')).to_equal('Khan');
  end last_only;
end test_t011_full_name;
/
