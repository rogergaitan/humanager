class RemoveFieldsFromPaymentType < ActiveRecord::Migration
  def up
    remove_column :payment_types, :description
    remove_column :payment_types, :state
  end

  def down
    add_column :payment_types, :state, :enum
    add_column :payment_types, :description, :string
  end
end
