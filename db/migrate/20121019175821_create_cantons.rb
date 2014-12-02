class CreateCantons < ActiveRecord::Migration
  def change
    create_table :cantons do |t|
      t.references :province
      t.string :name

      t.timestamps
    end
    add_index :cantons, :province_id
  end
end
