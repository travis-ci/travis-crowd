Feature: Ordering a package

  Scenario: Ordering a package not being signed in
    When I go to the order page for the "Medium" package
    Then I should see "Package: Medium"
    When I fill in the following:
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
     And the credit card service returns a credit card token
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | card  | 12345678       |
     And the credit card service will create the following charge:
      | customer    | 1      |
      | amount      | 7000   |
      | description | medium |
      | currency    | usd    |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "sven@email.com"
     And I should see "Medium"
    When I go to my profile page
    Then I should see "Medium" within the packages list

  Scenario: Ordering a package being signed in
    Given I am signed in as "sven@email.com"
    When I go to the order page for the "Medium" package
    Then I should see "Package: Medium"
    And I should not see the following form fields: Email, Password
    When I fill in the following:
      | Street         | Grünberger 65 |
      | Zip            | 10245         |
      | City           | Berlin        |
      | Country        | Germany       |
      | Number         | 123456        |
      | Security code  | 123           |
     And the credit card service returns a credit card token
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | card  | 12345678       |
     And the credit card service will create the following charge:
      | customer    | 1      |
      | amount      | 7000   |
      | description | medium |
      | currency    | usd    |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "sven@email.com"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "Medium" within the packages list

  Scenario: Ordering a subscription not being signed in
    When I go to the order page for the "Medium" subscription
    Then I should see "Subscription: Medium"
    When I fill in the following:
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
     And the credit card service returns a credit card token
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | plan  | medium         |
      | card  | 12345678       |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "sven@email.com"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "Medium" within the subscriptions list

