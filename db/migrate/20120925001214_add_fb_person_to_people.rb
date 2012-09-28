class AddFbPersonToPeople < ActiveRecord::Migration
  def change
    add_column :people, :fb_person, :string
  end
end
