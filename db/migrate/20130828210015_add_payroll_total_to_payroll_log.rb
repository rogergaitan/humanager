class AddPayrollTotalToPayrollLog < ActiveRecord::Migration
  def change
  	add_column :payroll_logs, :payroll_total, :decimal, :precision => 18, :scale => 4
  end
end
