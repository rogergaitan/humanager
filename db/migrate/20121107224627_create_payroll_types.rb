class CreatePayrollTypes < ActiveRecord::Migration
  def change
    create_table :payroll_types do |t|
      t.string :description
      t.column :payroll_type, :enum, :limit => [:Administrativa, :Campo, :Planta]

      t.timestamps
    end
  end
end
