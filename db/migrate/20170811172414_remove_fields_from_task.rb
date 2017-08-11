class RemoveFieldsFromTask < ActiveRecord::Migration
  def change
    remove_column :tasks, :iaccount
    remove_column :tasks, :mlaborcost
    remove_column :tasks, :unit_performance
  end
end
