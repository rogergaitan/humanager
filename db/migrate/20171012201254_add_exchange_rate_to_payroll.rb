class AddExchangeRateToPayroll < ActiveRecord::Migration
  def change
    add_column :payrolls, :exchange_rate, :decimal, precision: 12, scale: 2
  end
end
