class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :document_number
      t.references :vendor
      t.date :purchase_date
      t.boolean :completed
      t.string :currency
      t.float :subtotal
      t.float :taxes
      t.float :total
      t.column :purchase_type, :enum, :limit => [:local, :imported]
      t.string :dai_tax
      t.string :isc_tax

      t.timestamps
    end
    add_index :purchases, :vendor_id
  end
end
