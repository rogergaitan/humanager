class ResponsibleToEmployeeId < ActiveRecord::Migration
  def up
	rename_column :cost_centers, :responsible, :employee_id
  end

  def down
  end
end
