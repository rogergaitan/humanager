class Canton < ActiveRecord::Base
  belongs_to :province
  has_many :districts
  has_many :addresses
  attr_accessible :name, :province_id
end
