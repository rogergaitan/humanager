class CreatePaymentSchedules < ActiveRecord::Migration
  def change
    create_table :payment_schedules do |t|
      t.string :description
      t.references :employee
      t.date :initial_date
      t.date :end_date

      t.timestamps
    end
    add_index :payment_schedules, :employee_id
  end
end
