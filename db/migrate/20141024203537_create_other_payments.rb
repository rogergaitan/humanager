class CreateOtherPayments < ActiveRecord::Migration
  def change
    create_table :other_payments do |t|
      t.references :costs_center
      t.references :ledger_account
      t.string :description
      t.column :deduction_type, :enum, :limit =>[:constant, :unique, :amount_to_exhaust]
      t.column :calculation_type, :enum, :limit =>[:percentage, :fixed]
      t.decimal :amount, :precision => 10, :scale => 2
      t.column :state, :enum, :limit =>[:completed, :active], :default => :active
      t.boolean :constitutes_salary
      t.boolean :individual

      t.timestamps
    end
    add_index :other_payments, :costs_center_id
    add_index :other_payments, :ledger_account_id
  end
end
