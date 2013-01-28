class AddPositionIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :position_id, :string
    add_index :employees, :position_id
  end
end
