# == Schema Information
#
# Table name: other_salaries
#
#  id                :integer          not null, primary key
#  description       :string(255)
#  ledger_account_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  amount            :decimal(18, 2)
#  state             :boolean          default(TRUE)
#

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
