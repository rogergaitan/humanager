class Address < ActiveRecord::Base
  belongs_to :entity
  belongs_to :province
  belongs_to :canton
  belongs_to :district
  attr_accessible :address
end
