Feature: Get on a plane
  In order to meet fellow passengers
  As a frequent flyer
  I want to enter my flight number and date
  
  Scenario: you're the first on that flight
    Given a user "langalex" is signed in
    When I go to the start page
      And I follow "Enter New Flight"
      And I fill in "AB8269" for "Flight Number"
      And I fill in "2010-09-08" for "Date"
      And I press "I'm on that plane"
    Then I should be on the page for flight "AB8269"
      And I should see "langalex" within "#passengers"
  
  Scenario: someone has entered that flight already
    Given a user "langalex" is signed in
      And a user with the login "roidrage"
      And a flight "AB123" on "2010-09-08"
      And "roidrage" in on flight "AB123" on "2010-09-08"
    When I go to the start page
      And I follow "Enter New Flight"
      And I fill in "AB123" for "Flight Number"
      And I fill in "2010-09-08" for "Date"
      And I press "I'm on that plane"
    Then I should be on the page for flight "AB123"
      And I should see "langalex" within "#passengers"
      And I should see "roidrage" within "#passengers"
