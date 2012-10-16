class PaymentFrequency < ActiveRecord::Base
	has_many :employees
  	attr_accessible :description, :name
end
