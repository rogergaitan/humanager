class OtherSalary < ActiveRecord::Base
	belongs_to :ledger_account
	#association with employees through other_salary_employees
  	has_many :other_salary_employees, :dependent => :destroy
  	has_many :employees, :through => :other_salary_employees

  	attr_accessible :description, :ledger_account_id, :amount, :employee_ids

	validates :description, 
					:presence => true	

	validates :ledger_account_id, 
					:presence => true	
end
