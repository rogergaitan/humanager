class RenameAmountColumnToPercentage < ActiveRecord::Migration
  def up
  	rename_column :taxes, :amount, :percentage
  end

  def down
  	rename_column :taxes, :percentage, :amount
  end
end
