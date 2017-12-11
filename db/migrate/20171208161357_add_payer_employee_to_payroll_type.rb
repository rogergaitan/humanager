class AddPayerEmployeeToPayrollType < ActiveRecord::Migration
  def up
    change_table :payroll_types do |t|      
      t.references :payer_employee
    end
  end

  def down
    change_table :payroll_types do |t|
      t.remove :payer_employee_id
    end
  end
end
