class AddNewFieldsToPayrollTypes < ActiveRecord::Migration
  def change
  	
  	add_column :payroll_types, :cod_doc_payroll_support, :integer, :precision => 3
  	add_column :payroll_types, :mask_doc_payroll_support, :string, :limit => 5
  	add_column :payroll_types, :cod_doc_accounting_support_mov, :integer, :precision => 3
  	add_column :payroll_types, :mask_doc_accounting_support_mov, :string, :limit => 5
  	add_column :payroll_types, :ledger_account_id, :integer
  	add_index :payroll_types, :ledger_account_id

  end
end
