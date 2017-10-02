class WorkBenefitsPayroll < ActiveRecord::Base
  belongs_to :work_benefit
  belongs_to :payroll
  
  attr_accessible :work_benefit_id, :payroll_id
end
