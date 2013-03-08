# == Schema Information
#
# Table name: other_salary_employees
#
#  id              :integer          not null, primary key
#  other_salary_id :integer
#  employee_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  amount          :decimal(18, 2)
#

class OtherSalaryEmployee < ActiveRecord::Base
  belongs_to :other_salary
  belongs_to :employee
  has_many :other_salary_payment, :dependent => :destroy
  attr_accessible :other_salary_id, :employee_id, :amount
end
