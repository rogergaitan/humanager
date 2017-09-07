class AddCalendarColorToPayrollType < ActiveRecord::Migration
  def change
    add_column :payroll_types, :calendar_color, :string
  end
end
