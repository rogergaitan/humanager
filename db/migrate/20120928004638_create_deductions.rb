class CreateDeductions < ActiveRecord::Migration
  def change
    create_table :deductions do |t|
      t.string :description
      t.references :employee
      t.string :frequency
      t.string :calculation_method

      t.timestamps
    end
    add_index :deductions, :employee_id
  end
end
