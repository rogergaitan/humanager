class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.references :employee

      t.timestamps
    end
    add_index :departments, :employee_id
  end
end
