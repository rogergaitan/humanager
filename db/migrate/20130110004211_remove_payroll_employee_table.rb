class RemovePayrollEmployeeTable < ActiveRecord::Migration
  def up
    drop_table :payroll_employees
  end

  def down
    create_table :payroll_employees, :force => true do |t|
      t.integer :employee_id
      t.integer :payroll_log_id
      t.timestamps
    end
    
    add_index :payroll_employees, :employee_id
    add_index :payroll_employees, :payroll_log_id
  end
end