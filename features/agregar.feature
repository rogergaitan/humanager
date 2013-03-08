Feature: Agregar
    As a user 
    I should be able to add according the requirements
    
    Scenarrio: Add new "linea"
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/lines')])[2]"
    And I click on "//a[contains(@href, '/lines/new')]"
    And I fill in "line_name" with "linea " name
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
  
    Scenario: Add new "Categories" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/categories')])[2]"
    And I click on "//a[contains(@href, '/categories/new')]"
    And I fill in "category_name" with "categoría " name
    And I fill in "category_code" code
    And I fill in "category_description" with "categoría-prueba"
    When I press on "//form[@id='new_category']/div[5]/input[1]"
    And I should see "Categoría creada correctamente"
    And I should see code 
    And I click on "//a[contains(text(),'Regresar')]"
    Then I should see code 

    Scenario: Add new "bodega" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/warehouses')])[2]"
    And I click on "//a[contains(@href, '/warehouses/new')]"
    And I fill in "warehouse_name" with "bodega " name
    And I fill in "warehouse_code" code
    And I fill in "warehouse_manager" with "manager 2"
    And I fill in "warehouse_description" with "3/3"
    And I fill in "warehouse_address" with "lourdes"
    And I press on "//form[@id='new_warehouse']/div[7]/input[1]"
    Then I should see "Bodega creada correctamente" 

    Scenario: Add new "Sub-línea" successfully
    Given I am on "http://localhost:3000/" Home page
    And I click on "(//a[contains(@href, '/sublines')])[2]"
    And I click on "//a[contains(@href, '/sublines/new')]"
    And I fill in "subline_description" with "Sublinea " name
    And I fill in "subline_code" code
    And I fill in "subline_name" with "Sublinea-prueba"
    When I press on "//form[@id='new_subline']/div[5]/input[1]"
    And I should see code 
    And I click on "//a[contains(text(),'Regresar')]"
    Then I should see code 

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
    And I fill in "product_name" with "producto " name
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
