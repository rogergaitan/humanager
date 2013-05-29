class AddNunidadToTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :nunidad, :string
  end
end
