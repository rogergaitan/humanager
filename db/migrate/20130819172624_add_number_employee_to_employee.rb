class AddNumberEmployeeToEmployee < ActiveRecord::Migration
  def change
  	add_column :employees, :number_employee, :integer
  	add_index :employees, :number_employee, :unique => true
  end
end
