class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :employee
      t.string :name
      t.string :photo

      t.timestamps
    end
    add_index :photos, :employee_id
  end
end
