class WorkBenefitsPayment < ActiveRecord::Base
  attr_accessible :employee_benefits_id, :payroll_id, :payment_date, :percentage, :payment, 
                  :state

  # has_many :employee_benefits
  # has_many :payrolls
  
  belongs_to :employee_benefit, foreign_key: 'employee_benefits_id'
  belongs_to :payroll
  belongs_to :currency
  
  def work_benefit_name
    employee_benefit.work_benefit.name    
  end
  
  def self.non_provisioned(payroll_id, employee_id)
    joins(:employee_benefit)
    .where('work_benefits_payments.payroll_id = ? and employee_benefits.employee_id = ?
           and provisioning = ?', payroll_id, employee_id, false)
  end
  
end
