class AddTaskCostToPayrollHistories < ActiveRecord::Migration
  def change
  	add_column :payroll_histories, :task_total, :decimal, :precision => 18, :scale => 4
  end
end