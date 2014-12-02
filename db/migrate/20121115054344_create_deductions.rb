class CreateDeductions < ActiveRecord::Migration
  def change
    create_table :deductions do |t|
      t.string :description
      t.column :deduction_type, :enum, :limit =>[:constant, :unique, :amount_to_exhaust]
      t.decimal :amount_exhaust, :decimal, :precision => 10, :scale => 2
      t.column :calculation_type, :enum, :limit =>[:percentage, :fixed]
      t.integer :ledger_account_id
      t.column :state, :enum, :limit =>[:completed, :active], :default => :active
      t.string :beneficiary_id
      t.boolean :is_beneficiary, :default => 1
      t.boolean :individual, :default => 0

      t.timestamps
    end
  end
end
