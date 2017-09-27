class AddCurrenctyToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.references :currency  
    end
  end
  
  def down
    remove_column :work_benefits, :currency_id
  end
  
end
