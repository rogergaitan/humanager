class AddBeneficiaryToWorkBenefits < ActiveRecord::Migration
  def change
  	add_column :work_benefits, :is_beneficiary, :boolean, :default => 1
  	add_column :work_benefits, :beneficiary_id, :integer
  	add_column :work_benefits, :centro_de_costo_id, :integer
  	add_index :work_benefits, :centro_de_costo_id
  end
end
