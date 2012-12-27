class CreatePaymentOptions < ActiveRecord::Migration
  def change
    create_table :payment_options do |t|
      t.string :name
      t.string :related_account
      t.boolean :use_expenses
      t.boolean :use_incomes
      t.boolean :require_transaction

      t.timestamps
    end
  end
end
