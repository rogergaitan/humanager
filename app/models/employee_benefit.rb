class EmployeeBenefit < ActiveRecord::Base
  attr_accessible :employee_id, :work_benefit_id
  belongs_to :work_benefit
  belongs_to :employee
  has_many :work_benefits_payments
end
