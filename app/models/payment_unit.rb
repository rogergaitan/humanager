class PaymentUnit < ActiveRecord::Base
  attr_accessible :description
  
  has_many :employees
end