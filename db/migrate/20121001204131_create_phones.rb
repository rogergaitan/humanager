class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone_type
      t.string :phone
      t.references :entity

      t.timestamps
    end
    add_index :phones, :entity_id
  end
end
