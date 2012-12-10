class DeductionEmployee < ActiveRecord::Base
  belongs_to :deduction
  belongs_to :employee
  attr_accessible :deduction_id, :employee_id
end
