class AddStateToWorkBenefits < ActiveRecord::Migration
  def change
  	add_column :work_benefits, :state, :boolean, :default => 1
  end
end
