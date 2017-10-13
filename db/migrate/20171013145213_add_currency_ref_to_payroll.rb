class AddCurrencyRefToPayroll < ActiveRecord::Migration
  def up
    change_table :payrolls do |t|
      t.references :currency  
    end
  end
  
  def down
    remove_column :payrolls, :currency_id
  end
  
end
