class CreatePaymentUnits < ActiveRecord::Migration
  def change
    create_table :payment_units do |t|
      t.string :description

      t.timestamps
    end
  end
end