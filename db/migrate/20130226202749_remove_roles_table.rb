class RemoveRolesTable < ActiveRecord::Migration
  def up
  	drop_table :roles
  end

  def down
  	create_table :roles, :force => true do |t|
      t.integer :description
      t.timestamps
    end
  end
end
