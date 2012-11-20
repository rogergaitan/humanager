class CreateDeductions < ActiveRecord::Migration
  def change
    create_table :deductions do |t|
      t.string :description
      t.column :deduction_type, :enum, :limit =>[:constante, :unica]
      t.decimal :amount_exhaust
      t.column :calculation_type, :enum, :limit =>[:porcentual, :fija]
      t.decimal :calculation, :precision => 18, :scale => 4
      t.integer :ledger_account_id

      t.timestamps
    end
  end
end
