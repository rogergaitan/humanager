class AddDocumentNumberToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :document_number, :string
  end
end
