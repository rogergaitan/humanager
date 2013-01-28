class AddStateToOtherSalary < ActiveRecord::Migration
  def change
    add_column :other_salaries, :state, :boolean, :default => 1
    add_column :other_salary_employees, :amount, :decimal, :precision => 18, :scale => 2
  end
end
