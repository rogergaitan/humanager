class Province < ActiveRecord::Base
  has_many :cantons
  attr_accessible :name
end
