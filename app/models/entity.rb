class Entity < ActiveRecord::Base
	has_one :employee
  	attr_accessible :entityid, :name, :surname, :typeid
end
