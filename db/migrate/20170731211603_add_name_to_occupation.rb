class AddNameToOccupation < ActiveRecord::Migration
  def change
    add_column :occupations, :name, :string
  end
end
