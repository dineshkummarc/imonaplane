Feature: Sign in via twitter
  In order to be able to search user's followers/followings
  As a developer
  I want users to sign up using twitter

  Scenario: press sign in without having an account
    Given twitter is set up for "langalex"
    When I go to the start page
      And I follow "Sign in with Twitter"
    Then I should see "Welcome @langalex"
    
  Scenario: press sign in with having an account
    Given twitter is set up for "langalex"
      And a user with the login "langalex"
    When I go to the start page
      And I follow "Sign in with Twitter"
    Then I should see "Welcome @langalex"
