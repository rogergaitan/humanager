class Position < ActiveRecord::Base
  attr_accessible :description, :position
  has_many :employees
  
  # Validations
  validates :position, :format => { :with => /^[A-Za-z0-9- ]+$/i }
  validates :position,  :presence => true,  length: { maximum: 30 }
  validates_uniqueness_of :position, case_sensitive: false                        

  validates :description, length: { maximum: 200 }
  
  def self.search(position)
    where("position LIKE ?", "#{position}%")
  end
end
