class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :role
      t.string :description
      t.references :department

      t.timestamps
    end
    add_index :roles, :department_id
  end
end
