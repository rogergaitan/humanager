class AddWorkBenefitCalculationTypeToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.column :calculation_type, :enum, limit: [:percentage, :fixed]
    end
  end
  
  def down
    remove_column :work_benefits, :calculation_type
  end
  
end
