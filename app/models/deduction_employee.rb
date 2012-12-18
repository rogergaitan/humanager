class DeductionEmployee < ActiveRecord::Base
  belongs_to :deduction
  belongs_to :employee
  has_many :deduction_payments, :dependent => :destroy
  attr_accessible :deduction_id, :employee_id, :current_balance
end
