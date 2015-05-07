class PayrollTypeBenefit < ActiveRecord::Base
  attr_accessible :payroll_type_id, :work_benefit_id
  belongs_to :payroll_type
  belongs_to :work_benefit
end
