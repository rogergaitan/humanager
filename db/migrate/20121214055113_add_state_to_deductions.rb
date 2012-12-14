class AddStateToDeductions < ActiveRecord::Migration
  def change
    add_column :deductions, :state, :boolean, :default => 1
  end
end
