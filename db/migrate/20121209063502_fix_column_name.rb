class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :payrolls, :star_date, :start_date
  end

  def down
  end
end
