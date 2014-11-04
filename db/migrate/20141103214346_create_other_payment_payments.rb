class CreateOtherPaymentPayments < ActiveRecord::Migration
  def change
    create_table :other_payment_payments do |t|
      t.references :other_payment_employee
      t.date :payment_date
      t.integer :payment

      t.timestamps
    end
    add_index :other_payment_payments, :other_payment_employee_id
  end
end
