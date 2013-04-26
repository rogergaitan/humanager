class CreateWorkBenefitsPayments < ActiveRecord::Migration
def change
    create_table :work_benefits_payments do |t|
      t.integer :employee_benefits_id
      t.integer :payroll_id
      t.date :payment_date
      t.decimal :percentage
      t.decimal :payment

      t.timestamps
    end
    add_index :work_benefits_payments, :employee_benefits_id
    add_index :work_benefits_payments, :payroll_id
  end
end