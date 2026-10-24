create or replace package test_onboarding_api as
  --%suite(t027 onboarding)

  --%test(phone number is saved)
  procedure phone_saved;

  --%test(e-mail is saved)
  procedure email_saved;

  --%test(second hire keeps own phone number)
  procedure second_hire;
end test_onboarding_api;
/
create or replace package body test_onboarding_api as
  procedure phone_saved is
  begin
    onboarding_api.add_hire(1, 'Ana Silva', 'ana@example.com', '555-0101');
    ut.expect(onboarding_api.phone_of(1)).to_equal('555-0101');
  end phone_saved;

  procedure email_saved is
  begin
    onboarding_api.add_hire(2, 'Bo Berg', 'bo@example.com', '555-0102');
    ut.expect(onboarding_api.email_of(2)).to_equal('bo@example.com');
  end email_saved;

  procedure second_hire is
  begin
    onboarding_api.add_hire(3, 'Cy Dahl', 'cy@example.com', '555-0103');
    onboarding_api.add_hire(4, 'Di Eng',  'di@example.com', '555-0104');
    ut.expect(onboarding_api.phone_of(4)).to_equal('555-0104');
  end second_hire;
end test_onboarding_api;
/
