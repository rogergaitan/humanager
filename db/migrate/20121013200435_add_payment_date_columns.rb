class AddPaymentDateColumns < ActiveRecord::Migration
  def up
  	add_column :payment_schedules, :payment_date, :date
  end

  def down
  	remove_column :payment_schedules, :payment_date
  end
end
