class OtherPayment < ActiveRecord::Base

  belongs_to :ledger_account
  belongs_to :costs_center

  attr_accessible :description, :deduction_type, :calculation_type, :amount, :state, :constitutes_salary, 
      :individual, :ledger_account_id, :payroll_type_ids, :costs_center_id, :other_payment_employees_attributes, 
      :custom_calculation, :payroll_ids, :employee_ids

  attr_accessor :custom_calculation, :employee_ids

  # association other_payments with payrolls
  has_many :other_payment_payrolls, :dependent => :destroy
  has_many :payrolls, :through => :other_payment_payrolls
  accepts_nested_attributes_for :other_payment_payrolls
  accepts_nested_attributes_for :payrolls

  has_many :payroll_type_other_payment, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_other_payment

  # association with other_payments through other_payment_employees
  has_many :other_payment_employees, :dependent => :destroy
  has_many :employees, :through => :other_payment_employees
  accepts_nested_attributes_for :other_payment_employees, :allow_destroy => true
  accepts_nested_attributes_for :employees, :allow_destroy => true

end
