class CreatePayrollEmployees < ActiveRecord::Migration
  def change
    create_table :payroll_employees do |t|
      t.references :employee
      t.references :payroll_history

      t.timestamps
    end
    add_index :payroll_employees, :employee_id
    add_index :payroll_employees, :payroll_history_id
  end
end

