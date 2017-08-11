class AddCurrencyRefToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :currency_id, :integer
  end
end
