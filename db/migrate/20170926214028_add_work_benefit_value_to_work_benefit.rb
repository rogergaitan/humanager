class AddWorkBenefitValueToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.decimal :work_benefits_value, precision: 12, scale: 2
    end
  end
  
  def down
    remove_column :work_benefits, :work_benefits_value
  end
  
end
