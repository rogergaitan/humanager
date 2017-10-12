class AddStateToPaymentType < ActiveRecord::Migration
  def up
    add_column :payment_types, :state, :enum, limit: [:completed, :active]
  end
  
  def down
    remove_column :payment_types, :state
  end
  
end
