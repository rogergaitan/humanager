class CreateItemsPurchaseOrders < ActiveRecord::Migration
  def change
    create_table :items_purchase_orders do |t|
      t.references :purchase_order
      t.string :product
      t.string :description
      t.integer :quantity
      t.float :cost_unit
      t.float :cost_total

      t.timestamps
    end
    add_index :items_purchase_orders, :purchase_order_id
  end
end
