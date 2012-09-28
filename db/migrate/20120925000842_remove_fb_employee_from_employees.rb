class RemoveFbEmployeeFromEmployees < ActiveRecord::Migration
  def up
    remove_column :employees, :fb_employee
  end

  def down
  end
end
