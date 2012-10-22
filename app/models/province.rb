class Province < ActiveRecord::Base
  has_many :addresses
  has_many :cantons
  has_many :districts
  has_many :entities
  attr_accessible :name
end
