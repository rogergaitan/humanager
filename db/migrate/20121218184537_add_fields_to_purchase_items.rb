class AddFieldsToPurchaseItems < ActiveRecord::Migration
  def change
    add_column :purchase_items, :warehouse_id, :integer
    add_column :purchase_items, :discount, :decimal, :precision => 17, :scale => 2
    
    add_index :purchase_items, :warehouse_id
  end
end
