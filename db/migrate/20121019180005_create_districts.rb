class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.references :canton
      t.references :province
      t.string :name

      t.timestamps
    end
    add_index :districts, :canton_id
    add_index :districts, :province_id
  end
end
