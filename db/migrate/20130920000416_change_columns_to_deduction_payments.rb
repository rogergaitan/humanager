class ChangeColumnsToDeductionPayments < ActiveRecord::Migration
   def change

  	change_column(:deduction_payments, :previous_balance, :decimal, :precision => 18, :scale => 2)
  	change_column(:deduction_payments, :payment, :decimal, :precision => 18, :scale => 2)
  	change_column(:deduction_payments, :current_balance, :decimal, :precision => 18, :scale => 2)

  end
end
