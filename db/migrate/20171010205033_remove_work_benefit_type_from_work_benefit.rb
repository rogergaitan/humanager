class RemoveWorkBenefitTypeFromWorkBenefit < ActiveRecord::Migration
  def up
    remove_column :work_benefits, :work_benefits_type
  end

  def down
    add_column :work_benefits, :work_benefits_type, :enum, limit: [:constant, :unique]
  end
end
