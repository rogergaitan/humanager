class Entity < ActiveRecord::Base
	has_one :employee
	has_many :telephones
	accepts_nested_attributes_for :telephones, :allow_destroy => true
  	attr_accessible :entityid, :name, :surname, :typeid, :telephones_attributes
end