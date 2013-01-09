class CreatePurchasePaymentOptions < ActiveRecord::Migration
  def change
    create_table :purchase_payment_options do |t|
      t.references :payment_option
      t.references :payment_type
      t.references :purchase
      t.string :number
      t.float :amount

      t.timestamps
    end
    add_index :purchase_payment_options, :payment_option_id
    add_index :purchase_payment_options, :payment_type_id
    add_index :purchase_payment_options, :purchase_id
  end
end
