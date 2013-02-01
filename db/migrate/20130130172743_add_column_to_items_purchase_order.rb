class AddColumnToItemsPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :items_purchase_orders, :tax, :float
  end
end
