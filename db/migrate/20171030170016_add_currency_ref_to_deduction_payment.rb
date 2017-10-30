class AddCurrencyRefToDeductionPayment < ActiveRecord::Migration
  def change
    change_table :deduction_payments do |t|
      t.references :currency  
    end
  end
end
