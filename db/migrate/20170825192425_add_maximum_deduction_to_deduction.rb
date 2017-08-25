class AddMaximumDeductionToDeduction < ActiveRecord::Migration
  def change
    add_column :deductions, :maximum_deduction, :integer
  end
end
