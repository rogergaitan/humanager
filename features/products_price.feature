Feature: Manage Product Prices
  In order to create a new product's price
  As an user
  I want to create and manage product's prices
  
  Scenario: Product Price List
    Given I have list of product's prices
    When I go to new product price
    Then I should see product's price form
