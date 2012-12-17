class FixColumnToDeductions < ActiveRecord::Migration
  def up
  	change_table :deductions do |t|
      t.change :deduction_type, :enum, :limit =>[:Constante, :Unica, :Monto_Agotar]
    end
  end

  def down
  end
end
