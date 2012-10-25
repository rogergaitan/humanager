class Entity < ActiveRecord::Base
	
  has_one  :employee, :dependent => :destroy
	has_many :telephones, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_one  :customer
  has_one  :vendor
	accepts_nested_attributes_for :telephones, :allow_destroy => true, :reject_if => proc { |attributes| attributes["telephone"].blank? }
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true 
  accepts_nested_attributes_for :contacts, :allow_destroy => true   
  
  attr_accessible :entityid, :name, :surname, :typeid, :telephones_attributes, 
                  :emails_attributes, :addresses_attributes, :contacts_attributes
end
