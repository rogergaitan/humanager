class CreateOtherPayments < ActiveRecord::Migration
  def change
    create_table :other_payments do |t|
      t.string :description
      t.column :deduction_type, :enum, :limit =>[:Constante, :Unica, :Monto_Agotar]
      t.column :calculation_type, :enum, :limit =>[:porcentual, :fija]
      t.decimal :amount, :precision => 18, :scale => 2
      t.boolean :state
      t.boolean :constitutes_salary
      t.boolean :individual
      t.integer :ledger_account_id
      t.integer :centro_de_costo_id

      t.timestamps
    end
  end
end
