class Occupation < ActiveRecord::Base
	has_many :employees
  	attr_accessible :description
end
