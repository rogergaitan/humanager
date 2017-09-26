class AddWorkBenefitTypeToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do  |t|
      t.column :work_benefits_type, :enum, limit: [:constant, :unique, :amount_to_exhaust]  
    end
  end
  
  def down
    remove_column :work_benefits, :work_benefits_type
  end
end
