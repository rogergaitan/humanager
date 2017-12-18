class AddConsecutiveNumberToCompany < ActiveRecord::Migration
  def up
    add_column :companies, :inum, :integer, :default => 1
  end

  def down
    remove_column :companies, :inum
  end

end
