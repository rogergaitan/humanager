class AddActivityNameToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :nactivity, :string
  end
end
