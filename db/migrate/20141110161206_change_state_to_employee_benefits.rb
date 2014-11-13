class ChangeStateToEmployeeBenefits < ActiveRecord::Migration
  def change
  	rename_column :employee_benefits, :state, :completed
  	change_column :employee_benefits, :completed, :boolean, :default => 0
  end

end
