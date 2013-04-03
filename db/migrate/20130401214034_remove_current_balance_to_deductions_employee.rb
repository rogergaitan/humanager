class RemoveCurrentBalanceToDeductionsEmployee < ActiveRecord::Migration
  def up
  	remove_column :deduction_employees, :current_balance
  end

  def down
  	add_column :deduction_employees, :current_balance
  end
end
