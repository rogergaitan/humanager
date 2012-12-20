 Feature: Bodegas
 As a user 
 I should be able to use "bodegas" according the requirements
 
    Scenario: Access to the "Bodegas" module
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/warehouses')])[2]"
    And I should see "Código"
    And I should see "Nombre"
    And I should see "Descripción"
    And I should see "Responsable"
    And I should see "Dirección" 
    And I should see "Acciones"
    Then I should see "Bodegas"

    Scenario: Save and Continuo when create a warehouse
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/warehouses')])[2]"
    And I click on "//a[contains(@href, '/warehouses/new')]"
    And I fill in "warehouse_name" with "bot"
    And I fill in "warehouse_code" code
    And I fill in "warehouse_manager" with "DwCE"
    And I fill in "warehouse_description" with "44"
    And I fill in "warehouse_address" with "San Pedro"
    And I press on "//form[@id='new_warehouse']/div[7]/input[2]"
    And I should see "Bodega creada correctamente"
    Then I should see "Nuevo registro de Bodega"

    Scenario: Delete warehouse "bodega"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/warehouses')])[2]"
    And I delete the row "//tr[1]/td[6]/a[2]"
    And I assert confirmation
    Then I should see "Bodega eliminada correctamente"

    Scenario: Add new "bodega" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/warehouses')])[2]"
    And I click on "//a[contains(@href, '/warehouses/new')]"
    And I fill in "warehouse_name" with "Clavos"
    And I fill in "warehouse_code" code
    And I fill in "warehouse_manager" with "DSE"
    And I fill in "warehouse_description" with "3/3"
    And I fill in "warehouse_address" with "lourdes"
    And I press on "//form[@id='new_warehouse']/div[7]/input[1]"
    Then I should see "Bodega creada correctamente" 

    Scenario: Edit code "bodega" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/warehouses')])[2]"
    And I click on "//tr[1]/td[6]/a[1]"
    And I fill in "warehouse_code" code
    And I fill in "warehouse_manager" with "DSE"
    And I fill in "warehouse_address" with "lourdes"
    And I press on "//input[@name='commit']"
    And I should see "Bodega actualizada correctamente"
    And I should see code
    And I press on "//a[contains(text(),'Regresar')]"
    Then I should see code