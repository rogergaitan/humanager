class AddCurrencyRefToOtherPaymentPayment < ActiveRecord::Migration
  def change
    change_table :other_payment_payments do |t|
      t.references :currency
    end
  end
end
