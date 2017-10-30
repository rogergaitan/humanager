class WorkBenefitsPayment < ActiveRecord::Base
  attr_accessible :employee_benefits_id, :payroll_id, :payment_date, :percentage, :payment, 
  :state

  # has_many :employee_benefits
  # has_many :payrolls
  
  belongs_to :employee_benefit, foreign_key: 'employee_benefits_id'
  belongs_to :payroll
  belongs_to :currency
end
