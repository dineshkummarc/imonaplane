Feature: Get on a plane
  In order to meet fellow passengers
  As a frequent flyer
  I want to enter my flight number and date
  
  Scenario: you're the first on that flight
    Given a user "langalex" is signed in
    When I go to the start page
      And I follow "Enter new Flight"
      And I fill in "AB8269" for "Flight Number"
      And I fill in "2010-09-08" for "Date"
      And I fill in "TLX" for "From"
      And I fill in "DUB" for "To"
      And I press "I'm on that Plane"
    Then I should be on the page for flight "AB8269"
      And I should see "langalex" within "#passengers"
      And I should see "TLX"
      And I should see "DUB"
      
  @javascript
  Scenario: the flight number already exists so the airports are known
    Given a flight "AB123" from "SXW" to "DUB"
      And a user "langalex" is signed in
    When I go to the start page
      And I follow "Enter new Flight"
      And I fill in "ab 123" for "Flight Number"
      And the change event for "#flight_number" gets triggered
    Then the "From" field should contain "SXW"
      
  Scenario: enter invalid data
    Given a user "langalex" is signed in
    When I go to the start page
      And I follow "Enter new Flight"
      And I press "I'm on that Plane"
    Then I should see "please enter a flight number"
      And I should see "let's keep this in the YYYY-MM-DD format please"
  
  Scenario: someone has entered that flight already
    Given a user "langalex" is signed in
      And a user with the login "roidrage"
      And a flight "AB123" on "2010-09-08"
      And "roidrage" in on flight "AB123" on "2010-09-08"
    When I go to the start page
      And I follow "Enter new Flight"
      And I fill in "AB123" for "Flight Number"
      And I fill in "2010-09-08" for "Date"
      And I press "I'm on that Plane"
    Then I should be on the page for flight "AB123"
      And I should see "langalex" within "#passengers"
      And I should see "roidrage" within "#passengers"

  Scenario: join via the flight page
    Given a user "langalex" is signed in
      And a user with the login "roidrage"
      And a flight "AB123" on "2010-09-08"
      And "roidrage" in on flight "AB123" on "2010-09-08"
    When I go to the page for flight "AB123"
      And I press "I'm on that Plane"
    Then I should be on the page for flight "AB123"
      And I should see "langalex" within "#passengers"
      And I should see "roidrage" within "#passengers"
      And I should see "You're on that plane"
  
  