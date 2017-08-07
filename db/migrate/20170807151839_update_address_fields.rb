class UpdateAddressFields < ActiveRecord::Migration
  def up
    add_column :addresses, :department, :string 
    add_column :addresses, :municipality, :string

    remove_column :addresses, :province_id
    remove_column :addresses, :canton_id
    remove_column :addresses, :district_id
  end
end
