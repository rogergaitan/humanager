class Deduction < ActiveRecord::Base
  attr_accessible :payroll_ids, :amount_exhaust, :calculation, :calculation_type, 
  			:ledger_account_id, :deduction_type, :description, :employee_ids, 
  			:payroll_type_ids, :current_balance, :state, :is_beneficiary, :beneficiary_id

  has_many :payroll_type_deductions, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_deductions

  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deduction_employees, :dependent => :destroy
  has_many :payrolls, :through => :deduction_payrolls
  has_many :employees, :through => :deduction_employees
  belongs_to :ledger_account

  validates :calculation, :presence => true

end