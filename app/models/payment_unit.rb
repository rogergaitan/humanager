class PaymentUnit < ActiveRecord::Base
  attr_accessible :description, :name
  
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  
  has_many :employees
end
