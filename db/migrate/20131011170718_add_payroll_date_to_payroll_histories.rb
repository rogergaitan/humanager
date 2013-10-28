class AddPayrollDateToPayrollHistories < ActiveRecord::Migration
  def change
  	add_column :payroll_histories, :payroll_date, :date
  end
end
