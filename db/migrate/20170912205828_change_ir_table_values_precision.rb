class ChangeIrTableValuesPrecision < ActiveRecord::Migration
  def up
    change_column :ir_table_values, :until, :decimal, precision: 12, scale: 2
    change_column :ir_table_values, :from, :decimal, precision: 12, scale: 2
  end
  
  def down
  end
  
end
