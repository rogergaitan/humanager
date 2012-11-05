class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.references :canton

      t.timestamps
    end
    add_index :districts, :canton_id
  end
end
