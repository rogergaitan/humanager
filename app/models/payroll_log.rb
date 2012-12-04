class PayrollLog < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :task
  belongs_to :centro_de_costos
  attr_accessible :date, :time_worked, :centro_de_costo_id, :task_id, :time_worked, :payment_type
end
