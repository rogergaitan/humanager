class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :customer_profile
      t.references :entity
      t.string :asigned_seller

      t.timestamps
    end
    add_index :customers, :customer_profile_id
    add_index :customers, :entity_id
  end
end
