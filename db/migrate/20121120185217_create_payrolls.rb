class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.integer :payroll_type_id
      t.date :start_date
      t.date :end_date
      t.date :payment_date
      t.boolean :state, :default => 1

      t.timestamps
    end
    add_index :payrolls, :payroll_type_id
  end
end
