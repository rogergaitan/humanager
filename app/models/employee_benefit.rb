class EmployeeBenefit < ActiveRecord::Base
  belongs_to :work_benefit
  belongs_to :employee
  # attr_accessible :title, :body
end
