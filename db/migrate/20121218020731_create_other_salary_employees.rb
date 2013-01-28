class CreateOtherSalaryEmployees < ActiveRecord::Migration
  def change
    create_table :other_salary_employees do |t|
      t.references :other_salary
      t.references :employee

      t.timestamps
    end
    add_index :other_salary_employees, :other_salary_id
    add_index :other_salary_employees, :employee_id
  end
end
