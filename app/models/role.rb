class Role < ActiveRecord::Base
	has_many :employees
  	attr_accessible :description, :rol
end
