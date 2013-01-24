class CreatePayrollLogs < ActiveRecord::Migration
  def change
    create_table :payroll_logs do |t|
      t.references :payroll
      t.date :date
      t.references :task
      t.decimal :time_worked
      t.references :centro_de_costo
      t.column :payment_type, :enum, :limit => [:Ordinario, :Extra, :Doble]
      t.timestamps
    end
    add_index :payroll_logs, :payroll_id
    add_index :payroll_logs, :task_id
    add_index :payroll_logs, :centro_de_costo_id
  end
end
