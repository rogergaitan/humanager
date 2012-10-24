class Address < ActiveRecord::Base

#Associations  
  belongs_to :entity
  belongs_to :province
  belongs_to :canton
  belongs_to :district

#Attributes accessibles
  attr_accessible :address, :province_id, :canton_id, :district_id
end
