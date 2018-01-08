class AddUniqueIndexToEmployeeAccountBncr < ActiveRecord::Migration
  def change
    add_index :employees, :account_bncr, unique: true
  end
end
