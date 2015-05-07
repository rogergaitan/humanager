class CreateDeductionPayments < ActiveRecord::Migration
  def change
    create_table :deduction_payments do |t|
      t.references :deduction_employee
      t.references :payroll
      t.date :payment_date
      t.decimal :previous_balance, :precision => 10, :scale => 2
      t.decimal :payment, :precision => 10, :scale => 2
      t.decimal :current_balance, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :deduction_payments, :deduction_employee_id
    add_index :deduction_payments, :payroll_id
  end
end
