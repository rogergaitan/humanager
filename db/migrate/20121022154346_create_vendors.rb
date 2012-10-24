class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :credit_limit
      t.references :entity

      t.timestamps
    end
    add_index :vendors, :entity_id
  end
end
