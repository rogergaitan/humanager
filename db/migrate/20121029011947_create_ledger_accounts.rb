class CreateLedgerAccounts < ActiveRecord::Migration
  def change
    create_table :ledger_accounts do |t|
      t.string :iaccount
      t.string :naccount
      t.string :ifather

      t.timestamps
    end
  end
end
