class CreateWorkBenefits < ActiveRecord::Migration
  def change
    create_table :work_benefits do |t|
      t.string :description
      t.references :employee
      t.string :frequency
      t.string :calculation_method

      t.timestamps
    end
    add_index :work_benefits, :employee_id
  end
end
