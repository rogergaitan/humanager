# == Schema Information
#
# Table name: entities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  entityid   :string(255)
#  typeid     :enum([:national,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

  validates :name, :surname, :entityid, :presence => true
end

