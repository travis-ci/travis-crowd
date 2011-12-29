Feature: Ordering a subscription

  Scenario: Not being signed in
    When I go to the subscription page for the "Medium" package
    And I fill in the following:
      | Name           | Sven Fuchs     |
      | Email          | sven@email.com |
      | Github handle  | svenfuchs      |
      | Twitter handle | svenfuchs      |
      | Password       | my-password    |
      | Street         | Grünberger 65  |
      | Zip            | 10245          |
      | City           | Berlin         |
      | Country        | Germany        |
      | Number         | 123456         |
      | Security code  | 123            |
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | plan  | medium         |
      | card  |                |
      # card is empty because cucumber won't go through js
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "sven@email.com"
     And I should see "Medium"
    When I go to my profile page
    Then I should see "Medium"

  Scenario: Already being signed in
    Given I am signed in as "sven@email.com"
    When I go to the subscription page for the "Medium" package
    Then I should not see the following form fields: Email, Password
    And I fill in the following:
      | Street         | Grünberger 65 |
      | Zip            | 10245         |
      | City           | Berlin        |
      | Country        | Germany       |
      | Number         | 123456        |
      | Security code  | 123           |
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | plan  | medium         |
      | card  |                |
      # card is empty because cucumber won't go through js
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "sven@email.com"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "Medium"

