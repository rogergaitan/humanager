# == Schema Information
#
# Table name: entities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  entityid   :string(255)
#  typeid     :enum([:nacional,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Entity < ActiveRecord::Base

# Associations	
	has_one :employee
	has_one :vendor
	has_many :telephones
	has_many :contacts
	has_many :addresses
  has_one :customer

#Attributes accessibles
  	attr_accessible :entityid, :name, :surname, :typeid, 
  					:telephones_attributes,
  					:contacts_attributes,
  					:addresses_attributes

#Nested attributes
  	accepts_nested_attributes_for :telephones, :allow_destroy => true
  	accepts_nested_attributes_for :contacts, :allow_destroy => true
  	accepts_nested_attributes_for :addresses, :allow_destroy => true
end
