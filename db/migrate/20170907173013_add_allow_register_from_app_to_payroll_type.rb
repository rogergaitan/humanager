class AddAllowRegisterFromAppToPayrollType < ActiveRecord::Migration
  def change
    add_column :payroll_types, :allow_register_from_app, :boolean, default: false
  end
end
