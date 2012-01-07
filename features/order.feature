Feature: Ordering a package

  Scenario: Ordering a package not being signed in
    When I go to the order page for the "Medium" package
    Then I should see "Package: Medium"
    When I fill in the following:
      | Name     | Sven Fuchs     |
      | Email    | sven@email.com |
      | Github   | svenfuchs      |
      | Twitter  | @svenfuchs     |
      | Password | my-password    |
      | Street   | Grünberger 65  |
      | Zip      | 10245          |
      | City     | Berlin         |
      | Country  | Germany        |
      | Number   | 123456         |
      | CVC      | 123            |
     And the credit card service returns the credit card token "12345678"
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | card  | 12345678       |
     And the credit card service will create the following charge:
      | customer    | 1                       |
      | amount      | 7000                    |
      | description | sven@email.com (medium) |
      | currency    | usd                     |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Package: Medium"
    When I go to my profile page
    Then I should see "sven@email.com"
     And I should see "Medium" within the packages list
     And I should see "70" within the packages list

  Scenario: Ordering a package being signed in
    Given I am signed in as "sven@email.com" and I have the stripe customer id "1"
    When I go to the order page for the "Medium" package
    Then I should see "Package: Medium"
    And I should not see the following form fields: Email, Password
    When I fill in the following:
      | Name    | Sven Fuchs    |
      | Street  | Grünberger 65 |
      | Zip     | 10245         |
      | City    | Berlin        |
      | Country | Germany       |
     And the credit card service will not create a customer
     And the credit card service will create the following charge:
      | customer    | 1                       |
      | amount      | 7000                    |
      | description | sven@email.com (medium) |
      | currency    | usd                     |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "sven@email.com"
     And I should see "Medium" within the packages list
     And I should see "70" within the packages list

  Scenario: Ordering a subscription not being signed in
    When I go to the order page for the "Medium" subscription
    Then I should see "Subscription: Medium"
    When I fill in the following:
      | Name     | Sven Fuchs     |
      | Email    | sven@email.com |
      | Github   | svenfuchs      |
      | Twitter  | @svenfuchs     |
      | Password | my-password    |
      | Street   | Grünberger 65  |
      | Zip      | 10245          |
      | City     | Berlin         |
      | Country  | Germany        |
      | Number   | 123456         |
      | CVC      | 123            |
     And the credit card service returns the credit card token "12345678"
     And the credit card service will create a customer for:
      | email | sven@email.com |
      | plan  | medium         |
      | card  | 12345678       |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "sven@email.com"
     And I should see "Medium" within the subscriptions list
     And I should see "20" within the subscriptions list

  Scenario: Ordering a subscription being signed in
    Given I am signed in as "sven@email.com" and I have the stripe customer id "1"
    When I go to the order page for the "Medium" subscription
    Then I should see "Subscription: Medium"
    And I should not see the following form fields: Email, Password
    When I fill in the following:
      | Name    | Sven Fuchs    |
      | Street  | Grünberger 65 |
      | Zip     | 10245         |
      | City    | Berlin        |
      | Country | Germany       |
     And the credit card service will not create a customer
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "sven@email.com"
     And I should see "Medium" within the subscriptions list
     And I should see "20" within the subscriptions list

