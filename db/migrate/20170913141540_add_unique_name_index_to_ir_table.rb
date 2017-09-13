class AddUniqueNameIndexToIrTable < ActiveRecord::Migration
  def up
    add_index :ir_tables, :name, unique: true
  end
  
  def down
    remove_index :ir_tables, :name
  end
  
end
