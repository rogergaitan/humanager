class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :description, :percentage, :employee_ids
  
  has_many :employee_benefits, :dependent => :destroy
  has_many :employees, :through => :employee_benefits
  belongs_to :debit, class_name: 'LedgerAccount', foreign_key: "debit_account"
  belongs_to :credit, class_name: 'LedgerAccount', foreign_key: "credit_account"
end
