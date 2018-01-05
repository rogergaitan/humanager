class AddChildrenCountToLedgerAccount < ActiveRecord::Migration
  def change
    add_column :ledger_accounts, :children_count, :integer, default: 0
  end
end
