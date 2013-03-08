Feature: ProductoPrecio
 As a user 
 I should be able to use "bodegas" according the requirements
 
    Scenario: New price successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[2]"
    And I wait a second
    And I click on "//a[contains(text(),'Nuevo')]"
    And I wait 5 seconds
    And I fill in "product_pricing_utility" with "23"
    And I fill in "product_pricing_sell_price" with "200"
    And "credit" should be selected for "product_pricing[price_type]"
    And I wait a second
    And I press on "//form[@id='new_product_pricing']/div[4]/input"
    And I press on "//form[@id='new_product_pricing']/div[4]/button"
    Then I should see "Precio creado exitosamente"

   
    Scenario: edit price successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[2]"
    And I wait a second
    And I click on "//tr[1]/td[6]/a[1]"
    And I fill in "product_pricing_utility" with "333"
    And I fill in "product_pricing_sell_price" with "320"
    And "cash" should be selected for "product_pricing[price_type]"
    And I press on "//form[@id='new_product_pricing']/div[4]/input[1]"
    And I press on "//form[@id='new_product_pricing']/div[4]/button"
    Then I should see "Precio actualizado exitosamente" 


    Scenario: View product price successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[2]"
    And I should see "Producto"
    And I should see "Utilidad"
    And I should see "Categoría"
    And I should see "Precio Venta"
    And I should see "Acciones"


    Scenario: Delete price successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[2]"
    And I wait a second
    And I delete the row "//tr[1]/td[6]/a[2]"
    And I assert confirmation
    Then I should see "Precio eliminado correctamente"