    require 'capybara'
    require 'capybara/cucumber'
    require 'selenium-client'
    require 'selenium'

    Given /^I am on "([^""]*)" Home pege$/ do | url|
   	     visit(url)
         default_wait_time = 30
	end

	Then /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |txt, value|
	     fill_in(txt, :with => value)
	 end
    
    Then /^I press "([^""]*)"$/ do |button|
         click_button(button)
	end
    
    Then /^I should see "([^""]*)"$/ do |text|  
         page.should have_content(text)  
    end

    Given /^I am on the main google search$/ do
          visit ('https://google.com/')
          default_wait_time = 30
    end
     
   
    Then /^I click on "([^""]*)" bodegas$/ do |bodega| 
          find(:xpath,bodega).click
    end
     
    Then /^I click on the first result$/ do
          default_wait_time = 10
          find(:link, "Cucumber - Making BDD fun").click
          default_wait_time = 30          
    end