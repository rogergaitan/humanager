class AddMaximumDeductionCurrencyRefToDeduction < ActiveRecord::Migration
  def up
    add_column :deductions, :maximum_deduction_currency_id, :integer
  end
  
  def down
     remove_column :deductions, :maximum_deduction_currency_id
  end
  
end
