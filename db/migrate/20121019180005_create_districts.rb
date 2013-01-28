class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.references :canton
      t.references :province

      t.timestamps
    end
    add_index :districts, :canton_id
    add_index :districts, :province_id
  end
end
