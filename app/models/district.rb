class District < ActiveRecord::Base
  belongs_to :canton
  has_many :addresses
  attr_accessible :name, :canton_id, :province_id
end
