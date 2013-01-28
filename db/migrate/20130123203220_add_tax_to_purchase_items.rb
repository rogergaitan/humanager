class AddTaxToPurchaseItems < ActiveRecord::Migration
  def change
    add_column :purchase_items, :tax, :float
  end
end
