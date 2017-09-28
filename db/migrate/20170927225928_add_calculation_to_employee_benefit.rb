class AddCalculationToEmployeeBenefit < ActiveRecord::Migration
  def up
    change_table :employee_benefits do |t|
      t.decimal :calculation, precision: 12, scale: 2  
    end
  end
  
  def down
    remove_column :employee_benefits, :calculation
  end
end
