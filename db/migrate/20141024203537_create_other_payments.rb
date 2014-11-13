class CreateOtherPayments < ActiveRecord::Migration
  def change
    create_table :other_payments do |t|
      t.string :description
      t.column :deduction_type, :enum, :limit =>[:Constante, :Unica, :Monto_Agotar]
      t.column :calculation_type, :enum, :limit =>[:porcentual, :fija]
      t.decimal :amount, :precision => 10, :scale => 2
      t.column :state, :enum, :limit =>[:completed, :active], :default => :active
      t.boolean :constitutes_salary
      t.boolean :individual
      t.integer :ledger_account_id
      t.integer :centro_de_costo_id

      t.timestamps
    end
  end
end
