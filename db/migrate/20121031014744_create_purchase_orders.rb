class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.references :vendor
      t.string :reference_info
      t.string :currency
      t.text :observation
      t.float :subtotal
      t.float :taxes
      t.float :total
      t.date :delivery_date
      t.string :shipping_type

      t.timestamps
    end

    add_index :purchase_orders, :vendor_id
  end
end
