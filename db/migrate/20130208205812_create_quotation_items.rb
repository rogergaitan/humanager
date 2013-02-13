class CreateQuotationItems < ActiveRecord::Migration
  def change
    create_table :quotation_items do |t|
      t.references :quotation
      t.references :product
      t.string :code
      t.string :description
      t.float :quantity
      t.float :unit_price
      t.float :discount
      t.float :tax
      t.float :total
      t.references :warehouse

      t.timestamps
    end
    add_index :quotation_items, :quotation_id
    add_index :quotation_items, :product_id
    add_index :quotation_items, :warehouse_id
  end
end
