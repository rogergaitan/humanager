class AddBeneficiaryToDeductions < ActiveRecord::Migration
  def change
  	add_column :deductions, :is_beneficiary, :boolean, :default => 1
  	add_column :deductions, :beneficiary_id, :integer
  	add_index :deductions, :beneficiary_id
  end
end
