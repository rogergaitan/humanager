class PayrollLog < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :task
  belongs_to :centro_de_costo

  has_many :payroll_employees, :dependent => :destroy
  has_many :employees, :through => :payroll_employees

  attr_accessible :date, :time_worked, :centro_de_costo_id, :task_id, :time_worked, :payment_type, :employee_ids
end
