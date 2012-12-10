class CreateDeductionPayrolls < ActiveRecord::Migration
  def change
    create_table :deduction_payrolls do |t|
      t.references :deduction
      t.references :payroll

      t.timestamps
    end
    add_index :deduction_payrolls, :deduction_id
    add_index :deduction_payrolls, :payroll_id
  end
end
