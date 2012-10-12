class Employee < ActiveRecord::Base
  belongs_to :entity, :dependent => :destroy
  attr_accessible :join_date, :entity_attributes
  accepts_nested_attributes_for :entity
end