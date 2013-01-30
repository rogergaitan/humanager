class AddColumnToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :document_date, :date
  end
end
