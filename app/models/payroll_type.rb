class PayrollType < ActiveRecord::Base
  attr_accessible :description, :payroll_type
  validates :description, :presence => true, :uniqueness => true
end
