# == Schema Information
#
# Table name: employee_benefits
#
#  id              :integer          not null, primary key
#  work_benefit_id :integer
#  employee_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class EmployeeBenefit < ActiveRecord::Base
  attr_accessible :employee_id, :work_benefit_id
  belongs_to :work_benefit
  belongs_to :employee
end
