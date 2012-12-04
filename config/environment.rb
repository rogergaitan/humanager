# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Date::DATE_FORMATS.merge!(:default => "%d/%m/%Y")
Reasapp::Application.initialize!