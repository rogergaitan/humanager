class OtherSalaryEmployee < ActiveRecord::Base
  belongs_to :other_salary
  belongs_to :employee
  has_many :other_salary_payment, :dependent => :destroy
  attr_accessible :other_salary_id, :employee_id, :amount
end
