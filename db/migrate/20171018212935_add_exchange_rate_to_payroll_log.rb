class AddExchangeRateToPayrollLog < ActiveRecord::Migration
  def change
    add_column :payroll_logs, :exchange_rate, :decimal, precision: 10, scale: 2 
  end
end
