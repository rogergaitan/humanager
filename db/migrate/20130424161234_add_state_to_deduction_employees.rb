class AddStateToDeductionEmployees < ActiveRecord::Migration
  def change
  	add_column :deduction_employees, :state, :boolean, :default => 1
  end
end