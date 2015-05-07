class CreateOtherPaymentEmployees < ActiveRecord::Migration
  def change
    create_table :other_payment_employees do |t|
      t.references :other_payment
      t.references :employee
      t.boolean :completed, :default => 0
      t.decimal :calculation, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :other_payment_employees, :other_payment_id
    add_index :other_payment_employees, :employee_id
  end
end
