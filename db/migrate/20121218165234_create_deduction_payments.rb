class CreateDeductionPayments < ActiveRecord::Migration
  def change
    create_table :deduction_payments do |t|
      t.references :deduction_employee
      t.date :payment_date
      t.integer :previous_balance
      t.integer :payment
      t.integer :current_balance

      t.timestamps
    end
    add_index :deduction_payments, :deduction_employee_id
  end
end
