class CreateEmployeeBenefits < ActiveRecord::Migration
  def change
    create_table :employee_benefits do |t|
      t.references :work_benefit
      t.references :employee

      t.timestamps
    end
    add_index :employee_benefits, :work_benefit_id
    add_index :employee_benefits, :employee_id
  end
end
