class RemoveTypeIdFromEntity < ActiveRecord::Migration
  def up
    remove_column :entities, :typeid
  end

  def down
    add_column :entities, :typeid, :enum
  end
end
