class OtherSalaryEmployee < ActiveRecord::Base
  belongs_to :other_salary
  belongs_to :employee
  attr_accessible :other_salary_id, :employee_id
end
