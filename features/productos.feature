Feature: Productos
     As a user 
     I should be able to use "Producto" according the requirements
    
    Scenario: Access to the "Producto" module
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I should see "Parte"
    And I should see "Código"
    And I should see "Existencia"
    And I should see "Nombre"
    And I should see "Acciones" 
    And I should see "Categoría" 
    And I should see "Línea" 
    Then I should see "Sub-línea"


    Scenario: Add new line
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//a[contains(@href, '/products/new')]"
    And I fill in "product_code" code

    When I click on "//form[@id='new_product']/div[3]/div/a/div"
    And I click on pop
    And I wait a second

    And I fill in "product_part_number" code    
    And I fill in "product_name" with "nombre producto"
    And I fill in "product_make" with "marca"
    And I fill in "product_model" with "modelo"
    And I fill in "product_year" with "2012"
    And I fill in "product_version" with "Version"
    And I fill in "product_max_discount" with "12"
    And I fill in "product_address" with "116"
    And I fill in "product_max_cant" with "126"
    And I fill in "product_min_cant" with "12"
    And I fill in "product_cost" with "12356"
    And I fill in "product_bar_code" with "126"
    And I fill in "product_market_price" with "12"
    And I fill in "product_stock" with "12356" 
    And I press on "//form[@id='new_product']/div[21]/input[1]"
    And I should see "Producto creado exitosamente"
    When I should see code
    And I press on "//div[3]/a[1]"
    Then I should see code
      












