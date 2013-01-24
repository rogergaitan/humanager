class RemovePayrollLogFields < ActiveRecord::Migration
  def up
    remove_index :payroll_logs, :task_id
    remove_index :payroll_logs, :centro_de_costo_id
    
    remove_column :payroll_logs, :date
    remove_column :payroll_logs, :task_id
    remove_column :payroll_logs, :time_worked
    remove_column :payroll_logs, :centro_de_costo_id
    remove_column :payroll_logs, :payment_type
  end

  def down
    add_column :payroll_logs, :date, :date
    add_column :payroll_logs, :task_id, :integer
    add_column :payroll_logs, :time_worked, :string
    add_column :payroll_logs, :centro_de_costo_id, :integer
    add_column :payroll_logs, :payment_type, :string
    
    add_index :payroll_logs, :task_id
    add_index :payroll_logs, :centro_de_costo_id
  end
end