class CreatePermissionsCategories < ActiveRecord::Migration
  def change
  	create_table :permissions_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
