class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :bank
      t.string :bank_account
      t.string :sinpe
      t.string :account_title
      t.references :entity

      t.timestamps
    end
    add_index :bank_accounts, :entity_id
  end
end
