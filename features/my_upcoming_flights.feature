Feature: My upcoming flights
  In order to not confuse users abuot their flights
  As a eveloper
  I want them to see their upcoming flights

  Scenario: I have a past and an upcoming flight
    Given today is "2010-09-01"
      And a user "langalex" is signed in
      And a flight "AB123" on "2010-09-08"
      And "langalex" in on flight "AB123" on "2010-09-08"
      And a flight "AB456" on "2010-07-08"
      And "langalex" in on flight "AB456" on "2010-07-08"
    When I go to the start page
    Then I should see "AB123"
      But I should not see "AB456"