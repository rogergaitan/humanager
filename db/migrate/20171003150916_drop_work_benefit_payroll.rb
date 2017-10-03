class DropWorkBenefitPayroll < ActiveRecord::Migration
  def change
    drop_table :work_benefits_payrolls
  end
end
