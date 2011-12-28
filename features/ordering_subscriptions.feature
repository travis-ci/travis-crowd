Feature: Ordering a Subscription
  Scenario: Not having an account
    Given I do not have an account
     And I am on the home page
    When I click on "Donate" for the "medium" subscription
    When I sign in as "svenfuchs" using twitter
    Then I should see a new subscription form
    When I fill in the following:
      | Email         | svenfuchs@artweb-design.de |
      | Github handle | svenfuchs         |
      | Street        | Grünberger Str 65 |
      | Zip           | 10245             |
      | City          | Berlin            |
      | Country       | Germany           |
      | Number        | 123456            |
      | Security code | 123               |
     And I press "Confirm"
    Then I should see "Thank you for subscribing!"
     And I should see "Medium"

  Scenario: Already having an account
    Given I have the following account:
      | name           | Sven Fuchs           |
      | twitter_uid    | 12345678             |
      | twitter_handle | svenfuchs            |
      | homepage       | http://svenfuchs.com |
      | description    | My bio               |
     And I am on the home page
    When I click on "Donate" for the "medium" subscription
    When I sign in as "svenfuchs" using twitter
    Then I should see a new subscription form
    When I fill in the following:
      | Email         | svenfuchs@artweb-design.de |
      | Github handle | svenfuchs         |
      | Street        | Grünberger Str 65 |
      | Zip           | 10245             |
      | City          | Berlin            |
      | Country       | Germany           |
      | Number        | 123456            |
      | Security code | 123               |
     And I press "Confirm"
    Then I should see "Thank you for subscribing!"
     And I should see "Medium"

