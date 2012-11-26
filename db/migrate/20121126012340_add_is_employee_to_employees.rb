class AddIsEmployeeToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :is_superior, :boolean, :default => 0
  end
end
