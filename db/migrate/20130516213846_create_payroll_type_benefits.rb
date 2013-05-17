class CreatePayrollTypeBenefits < ActiveRecord::Migration
  def change
    create_table :payroll_type_benefits do |t|
      t.references :payroll_type
      t.references :work_benefit


      t.timestamps
    end
    add_index :payroll_type_benefits, :payroll_type_id
    add_index :payroll_type_benefits, :work_benefit_id
  end
end
