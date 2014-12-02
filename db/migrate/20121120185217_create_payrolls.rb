class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.references :company
      t.references :payroll_type
      t.date :start_date
      t.date :end_date
      t.date :payment_date
      t.boolean :state, :default => 1
      t.string :num_oper
      t.string :num_oper_2

      t.timestamps
    end
    add_index :payrolls, :payroll_type_id
    add_index :payrolls, :company_id
  end
end
