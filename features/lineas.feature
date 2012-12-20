     Feature: Lineas
     As a user 
     I should be able to use "Lineas" according the requirements
    
    Scenario: Access to the "Lineas" module
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    And I should see "Líneas"
    And I should see "Código"
    And I should see "Descripción"
    And I should see "Nombre"
    And I should see "Acciones" 
    Then I should see "General"

    Scenario: Add new line
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    And I click on "//a[contains(@href, '/lines/new')]"
    And I fill in "line_name" with "linea de prueba"
    And I fill in "line_code" code
    And I fill in "line_description" with "descrip"
    And I fill in "line_inventory" with "12345"
    And I fill in "line_sale_cost" with "123456"
    And I fill in "line_utility_adjusment" with "12356"
    And I fill in "line_lost_adjustment" with "123453"
    And I fill in "line_income" with "12351"
    And I fill in "line_sales_return" with "12516"
    And I fill in "line_purchase_return" with "12356"
    And I fill in "line_sale_tax" with "116"
    And I fill in "line_purchase_tax" with "126"
    And I press on "//form[@id='new_line']/div[5]/input[1]"
    And I should see "Línea creada correctamente"
    When I should see "Información general"
    And I press on "//div[3]/a[1]"
    Then I should see "General"
      
    Scenario: Edit line successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    And I click on "//tr[1]/td[4]/a[2]"
    And I fill in "line_code" code
    And I fill in "line_description" with "editado"
    And I fill in "line_inventory" with "555"
    And I fill in "line_sale_cost" with "6666"
    And I fill in "line_lost_adjustment" with "54545"
    And I fill in "line_sales_return" with "4545"
    And I fill in "line_purchase_return" with "4545"
    And I fill in "line_sale_tax" with "12216"
    When I press on "//input[@name='commit']"
    And I should see "Línea actualizada correctamente"
    And I should see code
    And I should see "Descripción: editado"
    And I should see "Información contable"
    And I press on "//a[contains(text(),'Regresar')]"
    Then I should see code  

    Scenario: View accounting Information successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    When I click on "//tr[1]/td[4]/a[1]"
    And I should see "Información general"
    And I should see "Información contable"
    And I should see "Impuestos"
    And I should see "Inventario:"
    And I should see "Impuesto/venta:"
    And I should see "Ajuste/pérdida:"
    And I should see "Ajuste/utilidad:"
    And I should see "Ingreso:"
    And I should see "Dev/venta:"
    And I should see "Dev/compra:"
    And I should see "Impuesto/compra:"
    And I should see "Código:"
    And I should see "Nombre:"
    And I should see "Descripción:"
    And I press on "//a[contains(text(),'Regresar')]"
    Then I should see "General"

    Scenario: Delete Lines 
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    And I can see the row "//td[4]/a[3]"
    And I delete the row "//tr[2]/td[4]/a[3]"
    And I assert confirmation
    Then I should see "Línea eliminada correctamente"

    Scenario: "Cancelar" button works as expected in "Nuevo registro de línea"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    When I click on "//a[contains(@href, '/lines/new')]"
    And I click on "//form[@id='new_line']/div[5]/a"
    Then I should see "General"

    Scenario: "Cancelar" button works as expected in "Editar Línea"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    When I click on "//a[contains(@href, '/lines/new')]"
    And I click on "//a[contains(text(),'Cancelar')]"
    Then I should see "General"

    Scenario: Add new line when press "Guardar y Continuar" 
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    And I click on "//a[contains(@href, '/lines/new')]"
    And I fill in "line_name" with "linea de prueba"
    And I fill in "line_code" code
    And I fill in "line_description" with "descrip"
    And I fill in "line_utility_adjusment" with "12356"
    When I press on "//form[@id='new_line']/div[5]/input[2]"
    And I should see "Línea creada correctamente"
    And I should see "Nuevo registro de Línea"
    And I fill in "line_name" with "linea de prueba"
    And I fill in "line_code" code
    And I fill in "line_description" with "descrip"
    And I fill in "line_inventory" with "12345"
    And I fill in "line_sale_cost" with "123456"
    And I fill in "line_lost_adjustment" with "123453"
    When I press on "//form[@id='new_line']/div[5]/input[2]"
    And I should see "Línea creada correctamente"
    And I should see "Nuevo registro de Línea"
    And I click on "//form[@id='new_line']/div[5]/a"
    Then I should see "General"









