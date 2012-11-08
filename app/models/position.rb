class Position < ActiveRecord::Base
  attr_accessible :description, :position, :codigo_ins, :codigo_ccss
  has_many :employees
  
  validates :position,  :presence => true,
                        :uniqueness => true
end
