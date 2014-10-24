class RemoveCalculationToDeductions < ActiveRecord::Migration
  def up
  	remove_column :deductions, :calculation
  end

  def down
  	add_column :deductions, :calculation, :precision => 18, :scale => 4
  end
end
