class RevomeCcssCalculatedToEmployees < ActiveRecord::Migration
  def up
  	remove_column :employees, :ccss_calculated
  end

  def down
  	add_column :employees, :ccss_calculated, :boolean => nil
  end
end
