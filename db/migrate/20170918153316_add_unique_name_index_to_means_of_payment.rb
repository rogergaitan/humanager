class AddUniqueNameIndexToMeansOfPayment < ActiveRecord::Migration
  def change
    add_index :means_of_payments, :name, unique: true
  end
end
