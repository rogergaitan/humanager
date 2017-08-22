class AddDeductionValueToDeduction < ActiveRecord::Migration
  def change
    add_column :deductions, :deduction_value, :decimal, precision:  10, scale: 2
  end
end
