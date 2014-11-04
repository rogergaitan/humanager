class CreateOtherPaymentEmployees < ActiveRecord::Migration
  def change
    create_table :other_payment_employees do |t|
      t.references :other_payment
      t.references :employee
      t.boolean :state
      t.decimal :calculation, :precision => 18, :scale => 2

      t.timestamps
    end
    add_index :other_salary_employees, :other_payment_id
    add_index :other_salary_employees, :employee_id
  end
end
