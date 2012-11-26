class AddInmediateSuperiorToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :employee_id, :integer
    
    add_index :employees, :employee_id
  end
end