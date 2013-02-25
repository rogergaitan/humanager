class AddColumnToPurchaseItem < ActiveRecord::Migration
  def change
    add_column :purchase_items, :code, :string
  end
end
