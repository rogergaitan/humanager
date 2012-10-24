class Address < ActiveRecord::Base
  belongs_to :province
  belongs_to :canton
  belongs_to :district
  belongs_to :entity
  attr_accessible :address, :province_id, :canton_id, :district_id
end
