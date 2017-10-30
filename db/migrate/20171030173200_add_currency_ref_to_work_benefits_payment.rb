class AddCurrencyRefToWorkBenefitsPayment < ActiveRecord::Migration
  def change
    change_table :work_benefits_payments do |t|
      t.references :currency
    end
  end
end
