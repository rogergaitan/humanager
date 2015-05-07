class CreatePayrollLogs < ActiveRecord::Migration
  def change
    create_table :payroll_logs do |t|
      t.references :payroll
      t.date :payroll_date
      t.decimal :payroll_total, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :payroll_logs, :payroll_id
  end
end
