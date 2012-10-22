class Department < ActiveRecord::Base
	belongs_to :employee
	has_many :employees
	has_many :roles
  attr_accessible :name, :employee_id
end
