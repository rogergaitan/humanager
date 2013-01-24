class CreatePayrollHistories < ActiveRecord::Migration
  def change
    create_table :payroll_histories do |t|
      t.date :record_date
      t.references :task
      t.string :time_worked
      t.references :centro_de_costo
      t.column :payment_type, :enum, :limit => [:Ordinario, :Extra, :Doble]
      t.references :payroll_log

      t.timestamps
    end
    add_index :payroll_histories, :task_id
    add_index :payroll_histories, :centro_de_costo_id
    add_index :payroll_histories, :payroll_log_id
  end
end
