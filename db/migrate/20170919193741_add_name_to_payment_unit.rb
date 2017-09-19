class AddNameToPaymentUnit < ActiveRecord::Migration
  def change
    add_column :payment_units, :name, :string
  end
end
