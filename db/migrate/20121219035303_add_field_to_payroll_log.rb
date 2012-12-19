class AddFieldToPayrollLog < ActiveRecord::Migration
  def change
    add_column :payroll_logs, :payroll_date, :date
    remove_column :payroll_histories, :record_date
  end
end
