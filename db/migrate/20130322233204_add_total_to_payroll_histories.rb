class AddTotalToPayrollHistories < ActiveRecord::Migration
  def change
  	add_column :payroll_histories, :total, :decimal, :precision => 18, :scale => 4
  end
end
