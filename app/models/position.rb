class Position < ActiveRecord::Base
  attr_accessible :description, :position
  has_many :employees
  
  validates :position,  :presence => true,
                        :uniqueness => true
end
