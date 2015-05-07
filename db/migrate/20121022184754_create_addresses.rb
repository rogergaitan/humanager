class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :entity
      t.references :province
      t.references :canton
      t.references :district
      t.string :address

      t.timestamps
    end
    add_index :addresses, :entity_id
    add_index :addresses, :province_id
    add_index :addresses, :canton_id
    add_index :addresses, :district_id
  end
end
