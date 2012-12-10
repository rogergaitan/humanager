 Feature: Bodegas
 As a user 
 I should be able to use "bodegas" according the requirements
    
    Scenario: Access to the "Bodegas" module
    Given I am on "http://ec2-184-73-44-205.compute-1.amazonaws.com/" Home pege
    And I click on "(//a[contains(@href, '/warehouses')])[2]" bodegas
    And I should see "Código"
    And I should see "Nombre"
    And I should see "Descripción"
    And I should see "Responsable"
    And I should see "Dirección" 
    And I should see "Acciones"
    Then I should see "Bodegas"

    Scenario: Add new "bodega" successfully
    Given I am on "http://ec2-184-73-44-205.compute-1.amazonaws.com/" Home pege
    And I click on bodegas
    And I press on "Nuevo"
    And I fill in "warehouse_name" with "Clavos"
    And I fill in "warehouse_code" with "1234-354"
    And I fill in "warehouse_manager" with "DSE"
    And I fill in "warehouse_description" with "3/3"
    And I fill in "warehouse_address" with "lourdes"
    Then I should see "Bodega creada correctamente" 


    Scenario: Fail when add new "bodega" with invalid code
    Given I am on "http://ec2-184-73-44-205.compute-1.amazonaws.com/" Home pege
    And I click on bodegas
    And I press on "Nuevo"
    And I fill in "warehouse_name" with "Clavos"
    And I fill in "warehouse_code" with "gergergerer-354"
    And I fill in "warehouse_manager" with "DSE"
    And I fill in "warehouse_description" with "3/3"
    And I fill in "warehouse_address" with "lourdes"
    Then I should see "Código demasiado largo"

    Scenario: Save and Continuo is working 
    Given I am on "http://ec2-184-73-44-205.compute-1.amazonaws.com/" Home pege
    And I click on bodegas
    And I press on "Nuevo"
    And I fill in "warehouse_name" with "botas"
    And I fill in "warehouse_code" with "123456-354"
    And I fill in "warehouse_manager" with "DCCE"
    And I fill in "warehouse_description" with "44"
    And I fill in "warehouse_address" with "San Pedro"a
    And I should see "Bodega creada correctamente"
    Then I should see "Bodega creada correctamente"
