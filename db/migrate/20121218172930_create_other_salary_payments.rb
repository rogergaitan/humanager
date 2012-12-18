class CreateOtherSalaryPayments < ActiveRecord::Migration
  def change
    create_table :other_salary_payments do |t|
      t.references :other_salary_employee
      t.date :payment_date
      t.integer :payment

      t.timestamps
    end
    add_index :other_salary_payments, :other_salary_employee_id
  end
end
