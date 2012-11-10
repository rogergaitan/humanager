class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :description, :percentage
  
  has_many :employee_benefits
  has_many :employees, :through => :employee_benefits
end
