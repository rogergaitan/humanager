class CreateWorkBenefitsPayrolls < ActiveRecord::Migration
  def change
    create_table :work_benefits_payrolls do |t|
      t.references :work_benefit
      t.references :payroll
    end
    add_index :work_benefits_payrolls, :work_benefit_id
    add_index :work_benefits_payrolls, :payroll_id
  end
end
