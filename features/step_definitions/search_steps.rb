    require 'capybara'
    require 'capybara/cucumber'
    require 'selenium-client'
    require 'selenium'


    @global
    @var

 Given /^I am on "([^""]*)" Home page$/ do | url|
       visit(url)
       default_wait_time = 30
	end

	Then /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |txt, value|
        fill_in(txt, :with => value)
        default_wait_time = 30
    end

  Then /^(?:|I )fill in "([^""]*)" code$/ do |txt|
        chars = ("a".."z").to_a
        @global = "#{rand(1..99)}-#{Array.new(3, '').collect{chars[rand(chars.size)]}.join}-#{rand(1..99)}"
        fill_in(txt,:with => @global)
	 end
    
  Then /^I press on "([^\"]*)"$/ do |button|
        find(:xpath, button).click
        default_wait_time = 30
	 end
    
  Then /^I should see "([^""]*)"$/ do |text|  
        page.should have_content(text)  
        default_wait_time = 30
   end

  Then /^I click on "([^\"]*)"$/ do |botton| 
       find(:xpath,botton).click
       default_wait_time = 30
   end
     
 Then /^I click on eliminar$/ do
       find(:xpath, "(//a[contains(@href, '/warehouses/3')])[3]").click
       default_wait_time = 30
    end  
     
  Then /^I should see code$/ do  
       page.should have_content(@global)  
       default_wait_time = 30
    end

  Then /^I assert confirmation$/ do
       page.driver.browser.switch_to.alert.accept
      
     default_wait_time = 30
    end
        
   Then /^I delete the row "([^""]*)"$/ do |valor|
       default_wait_time = 30
       find(:xpath, valor).click 
       
     end

 Then /^I can see the row "([^\"]*)"$/ do |position|
         def is_element_present(position)
         @var=true
         end
        default_wait_time = 30
    end 

 
  Then /^I wait a second$/ do 
    default_wait_time = 60
  end

   Then /^I click on css "([^\"]*)"$/ do |position|
       find(:link, position).click

       default_wait_time = 30
    end  

Then /^I click on pop$/ do 

        within("div#lines_list") do
        find(:xpath, "//div[@id='lines_list']/div/div[2]/button").click

        
        end
             default_wait_time = 30
    end 