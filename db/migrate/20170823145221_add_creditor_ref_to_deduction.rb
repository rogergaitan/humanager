class AddCreditorRefToDeduction < ActiveRecord::Migration
  def up
    change_table :deductions do |t|
      t.references :creditor  
    end
  end
  
  def down
    remove_column :deductions, :creditor_id  
  end
end
