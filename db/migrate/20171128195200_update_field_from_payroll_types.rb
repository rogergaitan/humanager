class UpdateFieldFromPayrollTypes < ActiveRecord::Migration
  def up
    change_column :payroll_types, :cod_doc_payroll_support, :integer
    change_column :payroll_types, :mask_doc_payroll_support, :string
    change_column :payroll_types, :cod_doc_accounting_support_mov, :integer
    change_column :payroll_types, :mask_doc_accounting_support_mov, :string
  end
end
