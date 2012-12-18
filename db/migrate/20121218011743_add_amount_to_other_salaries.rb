class AddAmountToOtherSalaries < ActiveRecord::Migration
  def change
    add_column :other_salaries, :amount, :decimal,:precision => 18, :scale => 2
  end
end
