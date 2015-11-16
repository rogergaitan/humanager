class CreatePayrollHistories < ActiveRecord::Migration
  def change
    create_table :payroll_histories do |t|
      t.references :task
      t.references :costs_center
      t.references :payroll_log
      t.references :payment_type
      t.string :time_worked
      t.decimal :total, :precision => 10, :scale => 2
      t.decimal :task_total, :precision => 10, :scale => 2
      t.decimal :performance, :precision => 10, :scale => 2
      t.string :task_unidad
      t.date :payroll_date

      t.timestamps
    end
    add_index :payroll_histories, :task_id
    add_index :payroll_histories, :costs_center_id
    add_index :payroll_histories, :payroll_log_id
    add_index :payroll_histories, :payment_type_id
  end
end
