class Entity < ActiveRecord::Base
	has_one :employee
  	attr_accessible :entityid, :name, :surname, :typeid
  	#accepts_nested_attributes_for :employees
end
