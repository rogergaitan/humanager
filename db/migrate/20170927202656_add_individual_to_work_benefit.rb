class AddIndividualToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.boolean :individual  
    end
  end
  
  def down
    remove_column :work_benefits, :individual
  end
  
end
