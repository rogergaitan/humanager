class CreatePaymentSchedules < ActiveRecord::Migration
  def change
    create_table :payment_schedules do |t|
      t.string :code
      t.string :description
      t.date :initial_date
      t.date :end_date

      t.timestamps
    end
  end
end
