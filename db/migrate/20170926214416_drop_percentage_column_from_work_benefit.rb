class DropPercentageColumnFromWorkBenefit < ActiveRecord::Migration
  def up
    remove_column :work_benefits, :percentage
  end

  def down
    add_column :work_benefits, :percentage, :decimal
  end
end
