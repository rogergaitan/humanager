class ChangeDescriptionOnOtherPayment < ActiveRecord::Migration
  def up
    rename_column :other_payments, :description, :name
  end

  def down
  end
end
