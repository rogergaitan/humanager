class PayrollEmployee < ActiveRecord::Base
  belongs_to :employee
  belongs_to :payroll_log
  # attr_accessible :title, :body
end
