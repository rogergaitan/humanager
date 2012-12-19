class CreatePurchaseItems < ActiveRecord::Migration
  def change
    create_table :purchase_items do |t|
      t.references :purchase
      t.references :product
      t.string :description
      t.float :quantity
      t.float :cost_unit
      t.float :cost_total

      t.timestamps
    end
    add_index :purchase_items, :purchase_id
    add_index :purchase_items, :product_id
  end
end
