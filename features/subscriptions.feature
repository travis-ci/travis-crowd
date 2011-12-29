Feature: Ordering a subscription

  Scenario: Not being signed in
    When I go to the subscription page for the "Medium" package
    And I fill in the following:
      | Name           | Sven Fuchs                 |
      | Email          | svenfuchs@artweb-design.de |
      | Github handle  | svenfuchs                  |
      | Twitter handle | svenfuchs                  |
      | Password       | my-password                |
      | Street         | Grünberger Str 65          |
      | Zip            | 10245                      |
      | City           | Berlin                     |
      | Country        | Germany                    |
      | Number         | 123456                     |
      | Security code  | 123                        |
     And the credit card service will create a customer for:
      | description | svenfuchs@artweb-design.de |
      | plan        | medium                     |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "svenfuchs@artweb-design.de"
     And I should see "Medium"
    When I go to my profile page
    Then I should see "Medium"

  Scenario: Already being signed in
    Given I am signed in as "svenfuchs@artweb-design.de"
    When I go to the subscription page for the "Medium" package
    Then I should not see the following form fields: Email, Password
    And I fill in the following:
      | Street         | Grünberger Str 65          |
      | Zip            | 10245                      |
      | City           | Berlin                     |
      | Country        | Germany                    |
      | Number         | 123456                     |
      | Security code  | 123                        |
     And the credit card service will create a customer for:
      | description | svenfuchs@artweb-design.de |
      | plan        | medium                     |
     And I press "Confirm"
    Then I should see "Thank you"
     And I should see "Medium"
     And I should see "svenfuchs@artweb-design.de"
     And I should see "Berlin"
    When I go to my profile page
    Then I should see "Medium"

