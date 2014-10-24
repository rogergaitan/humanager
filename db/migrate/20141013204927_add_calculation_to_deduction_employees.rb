class AddCalculationToDeductionEmployees < ActiveRecord::Migration
  def change
  	add_column :deduction_employees, :calculation, :decimal, :precision => 18, :scale => 4
  end
end
