class CreatePermissionsSubcategories < ActiveRecord::Migration
  def change
  	create_table :permissions_subcategories do |t|
      t.string :name
      t.references :permissions_category
      t.timestamps
    end
    add_index :permissions_subcategories, :permissions_category_id
  end
end
