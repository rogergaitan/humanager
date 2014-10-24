class ChangeBeneficiaryIdToDeductions < ActiveRecord::Migration
  def change
  	change_column(:deductions, :beneficiary_id, :string)
  end
end
