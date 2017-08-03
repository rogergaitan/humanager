class Position < ActiveRecord::Base
  attr_accessible :description, :position
  has_many :employees
  
  validates :position,  :presence => true,
                        :uniqueness => true
  
  validates :position, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }
  
  def self.search(position)
    where("position LIKE ?", "#{position}%")
  end
end
