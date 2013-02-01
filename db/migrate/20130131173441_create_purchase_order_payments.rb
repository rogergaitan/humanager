class CreatePurchaseOrderPayments < ActiveRecord::Migration
  def change
    create_table :purchase_order_payments do |t|
      t.references :payment_option
      t.references :payment_type
      t.references :purchase_order
      t.string :number
      t.float :amount

      t.timestamps
    end
    add_index :purchase_order_payments, :payment_option_id
    add_index :purchase_order_payments, :payment_type_id
    add_index :purchase_order_payments, :purchase_order_id
  end
end
