class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.references :invoice
      t.references :warehouse
      t.string :code
      t.string :description
      t.float :ordered_quantity
      t.float :available_quantity
      t.float :quantity
      t.float :cost_unit
      t.float :discount
      t.float :tax
      t.float :cost_total
      t.references :product

      t.timestamps
    end
    add_index :invoice_items, :invoice_id
    add_index :invoice_items, :warehouse_id
    add_index :invoice_items, :product_id
  end
end
