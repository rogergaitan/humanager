class ChangeDeductionTypeOnOtherPayment < ActiveRecord::Migration
  def up
    rename_column :other_payments, :deduction_type, :other_payment_type
  end
    
  def down 
  end
end
