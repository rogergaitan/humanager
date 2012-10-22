class Entity < ActiveRecord::Base
	has_one :employee
	has_many :telephones
  has_many :emails
  has_many :addresses
  belongs_to :province
	accepts_nested_attributes_for :telephones, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  
  attr_accessible :entityid, :name, :surname, :typeid, :telephones_attributes, :emails_attributes, :addresses_attributes
end