class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.references :entity
      t.string :credit_limit

      t.timestamps
    end
    add_index :vendors, :entity_id
  end
end
