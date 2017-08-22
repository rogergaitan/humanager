class AddDeductionCurrencyRefToDeduction < ActiveRecord::Migration
  def change
    add_column :deductions, :deduction_currency_id, :integer
  end
end
