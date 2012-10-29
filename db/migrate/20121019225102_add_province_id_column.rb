class AddProvinceIdColumn < ActiveRecord::Migration
  def up
    add_column :districts, :province_id, :integer
    add_index :districts, :province_id
  end

  def down
    remove_column :districts, :province_id, :integer
    remove_index :districts, :province_id
  end
end