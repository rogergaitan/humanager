class AddCreditorRefToWorkBenefit < ActiveRecord::Migration
  def change
    change_table :work_benefits do |t|
      t.references :creditor  
    end
  end
  
  def down
    remove_column :work_benefits, :creditor_id
  end
  
end
