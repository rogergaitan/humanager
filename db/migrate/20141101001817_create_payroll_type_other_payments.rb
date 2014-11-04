class CreatePayrollTypeOtherPayments < ActiveRecord::Migration
  def change
    create_table :payroll_type_other_payments do |t|
      t.references :payroll_type
      t.references :other_payment

      t.timestamps
    end
    add_index :payroll_type_deductions, :payroll_type_id
    add_index :payroll_type_deductions, :other_payment_id
  end
end
