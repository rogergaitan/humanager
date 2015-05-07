class CreateOtherPaymentPayrolls < ActiveRecord::Migration
  def change
    create_table :other_payment_payrolls do |t|
      t.references :other_payment
      t.references :payroll

      t.timestamps
    end
    add_index :other_payment_payrolls, :other_payment_id
    add_index :other_payment_payrolls, :payroll_id
  end
end
