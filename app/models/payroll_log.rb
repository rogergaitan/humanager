class PayrollLog < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :task
  belongs_to :centro_de_costos
  has_many :payroll_employees, :dependent => :destroy
  has_many :employees, :through => :payroll_employees
  has_many :payroll_histories, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_histories, :allow_destroy => true, :reject_if => proc { |attributes| attributes["time_worked"].blank? }
  attr_accessible :payroll_histories_attributes, :employee_ids, :payroll_date
end
