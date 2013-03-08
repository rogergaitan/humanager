# == Schema Information
#
# Table name: other_salary_payments
#
#  id                       :integer          not null, primary key
#  other_salary_employee_id :integer
#  payment_date             :date
#  payment                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class OtherSalaryPayment < ActiveRecord::Base
  belongs_to :other_salary_employee
  attr_accessible :payment, :payment_date, :other_salary_employee_id
end
