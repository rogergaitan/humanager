Feature: Productos
    As a user 
    I should be able to use "Producto" according the requirements
    


    Scenario: Add new producto
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//a[contains(@href, '/products/new')]"
    And I fill in "product_code" code
    When I click on "//form[@id='new_product']/div[3]/div/a/div"
    And I wait 5 seconds
    And I click on "//div[@id='lines_list']/div[1]/div[1]/button"
    When I click on "//form[@id='new_product']/div[4]/div/a/div"
    And I wait 5 seconds
    And I click on "//div[@id='sublines_list']/div[1]/div[1]/button"
    When I click on "//form[@id='new_product']/div[5]/div/a/div"
    And I wait 5 seconds
    And I click on "//div[@id='category_list']/div[1]/div[1]/button"    
    And I wait a second
    And I fill in "product_part_number" code    
    And I fill in "product_name" with "producto - " name
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
    And "inactive" should be selected for "product[status]"
    And I press on "//form[@id='new_product']/div[21]/input[1]"
    And I should see "Producto creado exitosamente"
    When I should see code
    And I press on "//div[2]/a[1]"
    Then I should see code

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

    Scenario: Edit product successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[1]"
    And I fill in "product_code" code
    And I fill in "product_name" with "producto editado - " name 
    When I press on "//div[21]/input[1]"
    And I should see "Producto actualizado exitosamente"
    And I should see code
    And I should see "Código:"
    And I press on "//a[contains(text(),'Regresar')]"
    Then I should see code  


    Scenario: View price successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[2]"
    And I should see "Producto"
    And I should see "Utilidad"
    And I should see "Tipo de precio"
    And I should see "Categoría"
    And I should see "Precio Venta"
    And I should see "Acciones"
    And I should see "Precios"


    Scenario: "Cancelar" button works as expected when add new product
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//a[contains(@href, '/products/new')]"
    When I press on "(//a[contains(@href, '/products')])[2]"
    And I should see "Productos"
  

    Scenario: "Cancelar" button works as expected when edit product
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I click on "//tr[1]/td[8]/a[1]"
    When I press on "(//a[contains(@href, '/products')])[2]"
    And I should see "Productos"



    Scenario: Access to "Otros" products module
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    When I click on "//a[contains(text(),'Otros')]"
    And I should see "Min"
    And I should see "Max"
    And I should see "Dirección"
    And I should see "Código Barras"
    And I should see "Acciones" 
    Then I should see "Otros"


    Scenario: Edit "Otros" products successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    When I click on "//a[contains(text(),'Otros')]"
    And I click on "//tr[1]/td[5]/a[1]"
    And I fill in "product_code" code
    When I press on "//div[21]/input[1]"
    And I should see "Producto actualizado exitosamente"
    And I should see code
    And I should see "Código:"
    And I press on "//a[contains(text(),'Regresar')]"
    Then I should see code  


    Scenario: "Cancelar" button works as expected when add new other product
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    When I click on "//a[contains(text(),'Otros')]"
    And I click on "//a[contains(@href, '/products/new')]"
    When I press on "(//a[contains(@href, '/products')])[2]"
    And I should see "Productos"
  

    Scenario: "Cancelar" button works as expected when edit other product
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    When I click on "//a[contains(text(),'Otros')]"
    And I click on "//tr[1]/td[5]/a[1]"
    When I press on "(//a[contains(@href, '/products')])[2]"
    And I should see "Productos"

    
    Scenario: Delete other Product 
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    When I click on "//a[contains(text(),'Otros')]"
    And I delete the row "//tr[1]/td[5]/a[2]"
    And I assert confirmation
    Then I should see "Producto eliminado correctamente"


    Scenario: Delete Product 
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/products')])[3]"
    And I delete the row "//tr[1]/td[8]/a[3]"
    And I assert confirmation
    Then I should see "Producto eliminado correctamente"