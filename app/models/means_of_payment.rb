class MeansOfPayment < ActiveRecord::Base
	has_many :employees
  	attr_accessible :description, :name
end
