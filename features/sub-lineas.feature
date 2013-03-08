     Feature: Sub-Lineas
     As a user 
     I should be able to use "Sub-Lineas" according the requirements
   
    Scenario: Access to the "Sub-Lineas" module
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    And I should see "Código"
    And I should see "Nombre"
    And I should see "Descripción"
    And I should see "Acciones"
    Then I should see "Sub-Líneas" 
    

    Scenario: Add new "Sub-línea" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    And I click on "//a[contains(@href, '/sublines/new')]"
    And I fill in "subline_description" with "Sublinea - " name
    And I fill in "subline_code" code
    And I fill in "subline_name" with "Sublinea-prueba"
    When I press on "//form[@id='new_subline']/div[5]/input[1]"
    And I should see code 
    And I click on "//a[contains(text(),'Regresar')]"
    Then I should see code 

    Scenario: Edit subline successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    And I click on "//tr[1]/td[4]/a[1]"
    And I fill in "subline_code" code
    And I fill in "subline_description" with "editado - " name
    When I press on "//input[@name='commit']"
    And I should see "Sub-línea actualizada correctamente"
    And I should see code
    And I should see "Descripción: editado"
    And I press on "//a[contains(text(),'Regresar')][1]"
    Then I should see code 


    Scenario: "Cancelar" button works as expected in "Nuevo registro de Sub-línea"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    When I click on "//a[contains(@href, '/sublines/new')]"
    And I click on "//form[@id='new_subline']/div[5]/a"
    Then I should see "Acciones"


    Scenario: "Cancelar" button works as expected in "Editar Sub-Línea"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    And I click on "//tr[1]/td[4]/a[1]"
    And I click on "(//a[contains(@href, '/sublines')])[1]"
    Then I should see "Acciones"

    Scenario: Delete subline "Sub-línea"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    And I delete the row "//tr[1]/td[4]/a[2]"
    And I assert confirmation
    Then I should see "Sub-línea eliminada correctamente"