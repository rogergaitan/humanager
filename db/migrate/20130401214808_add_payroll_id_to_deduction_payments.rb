class AddPayrollIdToDeductionPayments < ActiveRecord::Migration
  def change
  	add_column :deduction_payments, :payroll_id, :integer
  	add_index :deduction_payments, :payroll_id
  end
end
