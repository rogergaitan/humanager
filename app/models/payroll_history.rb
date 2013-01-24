class PayrollHistory < ActiveRecord::Base
  belongs_to :task
  belongs_to :centro_de_costo
  belongs_to :payroll_log
  attr_accessible :time_worked, :task_id, :centro_de_costo_id, :payment_type, :payroll_log_id
end
