class AddUniqueNameIndexToPaymentFrequency < ActiveRecord::Migration
  def change
    add_index :payment_frequencies, :name, unique: true
  end
end
