class AddUniqueIndexToEmployeeSocialInsurance < ActiveRecord::Migration
  def change
    add_index :employees, :social_insurance, unique: true
  end
end
