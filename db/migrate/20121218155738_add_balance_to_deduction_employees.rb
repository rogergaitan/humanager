class AddBalanceToDeductionEmployees < ActiveRecord::Migration
  def change
    add_column :deduction_employees, :current_balance, :integer, :precision => 18, :scale => 2
  end
end
