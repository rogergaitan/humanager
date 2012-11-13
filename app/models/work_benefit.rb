class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :description, :percentage
  
  has_many :employee_benefits
  has_many :employees, :through => :employee_benefits
  belongs_to :debit_account, :class_name => "ledger_account", :foreign_key => "credit_account"
  belongs_to :credit_account, :class_name => "ledger_account", :foreign_key => "debit_account"
end
