class ChangeStateToDeductionEmployees < ActiveRecord::Migration
  def change
  	rename_column :deduction_employees, :state, :completed
  	change_column :deduction_employees, :completed, :boolean, :default => false
  end

end
