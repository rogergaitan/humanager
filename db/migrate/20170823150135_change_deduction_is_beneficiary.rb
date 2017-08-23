class ChangeDeductionIsBeneficiary < ActiveRecord::Migration
  def up
    rename_column :deductions, :is_beneficiary, :pay_to_employee
  end

  def down
    rename_column :deductions, :pay_to_employee, :is_beneficiary
  end
end
