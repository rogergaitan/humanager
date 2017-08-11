class AddCostToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :cost, :decimal, :precision => 10, :scale => 2
  end
end
