class CreatePayrollTypes < ActiveRecord::Migration
  def change
    create_table :payroll_types do |t|
      t.references :ledger_account
      t.string :description
      t.column :payroll_type, :enum, :limit => [:administrative, :fieldwork, :plant]
      t.boolean :state, :default => 1
      t.integer :cod_doc_payroll_support, :precision => 3
      t.string :mask_doc_payroll_support, :limit => 5
      t.integer :cod_doc_accounting_support_mov, :precision => 3
      t.string :mask_doc_accounting_support_mov, :limit => 5

      t.timestamps
    end
    add_index :payroll_types, :ledger_account_id
  end
end
