class Department < ActiveRecord::Base
	has_many :employees
  	belongs_to :employee
  	attr_accessible :name, :employee_id
end
