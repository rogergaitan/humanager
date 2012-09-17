# Controller of the application
class ApplicationController < ActionController::Base
  #Allows user to keep session on
  protect_from_forgery
end
