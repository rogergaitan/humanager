class AddStateToPayrollTypes < ActiveRecord::Migration
  def change
  	add_column :payroll_types, :state, :boolean, :default => 1
  end
end
