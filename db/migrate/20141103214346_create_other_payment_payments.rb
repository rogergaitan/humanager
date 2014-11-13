class CreateOtherPaymentPayments < ActiveRecord::Migration
  def change
    create_table :other_payment_payments do |t|
      t.references :other_payment_employee
      t.references :payroll
      t.date :payment_date
      t.decimal :payment, :precision => 10, :scale => 2
      t.boolean :is_salary, :default => 0

      t.timestamps
    end
    add_index :other_payment_payments, :other_payment_employee_id
    add_index :other_payment_payments, :payroll_id
  end
end
