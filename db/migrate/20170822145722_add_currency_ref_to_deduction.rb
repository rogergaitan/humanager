class AddCurrencyRefToDeduction < ActiveRecord::Migration
  def up
    add_column :deductions, :amount_exhaust_currency_id, :integer
  end
  
  def down
    remove_column :deductions, :amount_exhaust_currency_id
  end
end
