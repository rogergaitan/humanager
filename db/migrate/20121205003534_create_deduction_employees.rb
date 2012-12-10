class CreateDeductionEmployees < ActiveRecord::Migration
  def change
    create_table :deduction_employees do |t|
      t.references :deduction
      t.references :employee

      t.timestamps
    end
    add_index :deduction_employees, :deduction_id
    add_index :deduction_employees, :employee_id
  end
end
