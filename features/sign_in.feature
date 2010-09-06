Feature: Sign in via twitter
  In order to be able to search user's followers/followings
  As a developer
  I want users to sign up using twitter

  Scenario: press sign in without having an account
    Given twitter is set up
    When I go to the start page
      And I follow "Sign in with Twitter"
      And the twitter oauth goes through for "langalex"
    Then I should see "Welcome @langalex"
  
  
  