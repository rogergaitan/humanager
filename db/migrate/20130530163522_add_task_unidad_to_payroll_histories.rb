class AddTaskUnidadToPayrollHistories < ActiveRecord::Migration
  def change
  	add_column :payroll_histories, :task_unidad, :string
  end
end
