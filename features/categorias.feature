    Feature: Categorias
    As a user 
    I should be able to use "Categorías" according the requirements

    Scenario: Access to the "Categories" module
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    And I should see "Código"
    And I should see "Nombre"
    And I should see "Descripción"
    And I should see "Acciones"
    Then I should see "Categorías" 

    Scenario: Add new "Categories" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    And I click on "//a[contains(@href, '/categories/new')]"
    And I fill in "category_name" with "categoría - " name
    And I fill in "category_code" code
    And I fill in "category_description" with "categoría-prueba"
    When I press on "//form[@id='new_category']/div[5]/input[1]"
    And I should see "Categoría creada correctamente"
    And I should see code 
    And I click on "//a[contains(text(),'Regresar')]"
    Then I should see code 

    Scenario: Edit Categories successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    And I click on "//tr[1]/td[4]/a[1]"
    And I fill in "category_code" code
    And I fill in "category_description" with "editado - " name
    When I press on "//input[@name='commit']"
    And I should see "Categoría actualizada correctamente"
    And I should see code
    And I should see "Descripción: editado"
    And I press on "//a[contains(text(),'Regresar')][1]"
    Then I should see code 

    Scenario: "Cancelar" button works as expected in "Nuevo registro de Categories"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    When I click on "//a[contains(@href, '/categories/new')]"
    And I click on "//form[@id='new_category']/div[5]/a"
    Then I should see "Acciones"

    Scenario: "Cancelar" button works as expected in "Editar Categories"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    And I click on "//tr[1]/td[4]/a[1]"
    And I click on "(//a[contains(@href, '/categories')])[1]"
    Then I should see "Acciones"

    Scenario: Delete Categories 
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    And I delete the row "//tr[1]/td[4]/a[2]"
    And I assert confirmation
    Then I should see "Categoría eliminada correctamente"

