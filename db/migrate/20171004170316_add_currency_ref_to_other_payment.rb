class AddCurrencyRefToOtherPayment < ActiveRecord::Migration
  def change
    change_table :other_payments do |t|
      t.references :currency
    end
  end
end
