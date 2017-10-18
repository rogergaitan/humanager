class RemoveExchangeRateFromPayroll < ActiveRecord::Migration
  def up
    remove_column :payrolls, :exchange_rate
  end

  def down
    add_column :payrolls, :exchange_rate, :decimal
  end
end
