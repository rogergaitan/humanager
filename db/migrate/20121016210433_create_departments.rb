class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.references :employee
      t.references :costs_center
      t.string :name

      t.timestamps
    end
    add_index :departments, :employee_id
    add_index :departments, :costs_center_id
  end
end
