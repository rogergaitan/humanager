class CreateOtherSalaries < ActiveRecord::Migration
  def change
    create_table :other_salaries do |t|
      t.string :code
      t.string :description
      t.integer :ledger_account_id

      t.timestamps
    end
  end
end
