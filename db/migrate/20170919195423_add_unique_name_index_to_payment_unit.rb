class AddUniqueNameIndexToPaymentUnit < ActiveRecord::Migration
  def change
    add_index :payment_units, :name, unique: true
  end
end
