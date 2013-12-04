class AddBncrToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :account_bncr, :string, :limit => 12
  end
end
