class AddPayrollTypeDefaultToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :payroll_type_default_id, :integer
  	add_index :employees, :payroll_type_default_id
  end
end
