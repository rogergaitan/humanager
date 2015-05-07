class CreatePayrollTypeDeductions < ActiveRecord::Migration
  def change
    create_table :payroll_type_deductions do |t|
    	t.references :payroll_type
      	t.references :deduction

      t.timestamps
    end
    add_index :payroll_type_deductions, :payroll_type_id
    add_index :payroll_type_deductions, :deduction_id
  end
end
