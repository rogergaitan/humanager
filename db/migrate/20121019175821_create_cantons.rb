class CreateCantons < ActiveRecord::Migration
  def change
    create_table :cantons do |t|
      t.string :name
      t.references :province

      t.timestamps
    end
    add_index :cantons, :province_id
  end
end