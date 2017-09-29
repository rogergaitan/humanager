class AddPayToEmployeeToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.boolean :pay_to_employee
    end
  end
  
  def down
    remove_column :work_benefits, :pay_to_employee
  end
  
end
