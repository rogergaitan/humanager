class AddColumnsToLedgerAccount < ActiveRecord::Migration
  def change
    add_column :ledger_accounts, :account_type, :enum, :limit => [:asset, :liability, :equity, :income, :expense, :cost_sale]
    add_column :ledger_accounts, :cost_center, :boolean
    add_column :ledger_accounts, :foreign_currency, :boolean
    add_column :ledger_accounts, :request_entity, :boolean
  end
end
