class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.integer :canton_id
      t.string :district

      t.timestamps
    end
  end
end
