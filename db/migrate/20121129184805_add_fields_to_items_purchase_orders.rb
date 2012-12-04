class AddFieldsToItemsPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :items_purchase_orders, :warehouse_id, :integer
    add_column :items_purchase_orders, :discount, :decimal, :precision => 17, :scale => 2
    
    add_index :items_purchase_orders, :warehouse_id
  end
end