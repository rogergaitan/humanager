class OtherSalaryPayment < ActiveRecord::Base
  belongs_to :other_salary_employee
  attr_accessible :payment, :payment_date, :other_salary_employee_id
end
