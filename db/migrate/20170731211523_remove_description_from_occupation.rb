class RemoveDescriptionFromOccupation < ActiveRecord::Migration
  def up
    remove_column :occupations, :description
  end

  def down
    add_column :occupations, :description, :string
  end
end
