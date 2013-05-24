class AddStateToEmployeeBenefits < ActiveRecord::Migration
  def change
  	add_column :employee_benefits, :state, :boolean, :default => 1
  end
end
