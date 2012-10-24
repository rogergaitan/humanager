class Province < ActiveRecord::Base
  has_many :addresses
  has_many :cantons
  has_many :districts
  attr_accessible :name
end
