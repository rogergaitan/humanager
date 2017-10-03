class AddPayrollToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.references :payroll
    end
  end
  
  def down
  end
end
