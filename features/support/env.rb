require 'capybara'
require 'capybara/cucumber'
require 'selenium-client'
require 'selenium-webdriver'

	Capybara.default_driver = :selenium
	#Capybara.app_host = "https://facebook.com"
	Capybara.default_wait_time = 60
	Capybara.default_selector = :css
	Capybara.default_selector = :xpath
	Capybara.default_selector = :all
	Capybara.default_selector = :id
	Capybara.default_selector = :element
    
	 
	World(Capybara)