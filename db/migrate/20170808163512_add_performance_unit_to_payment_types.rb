class AddPerformanceUnitToPaymentTypes < ActiveRecord::Migration
  def change
    add_column :payment_types, :performance_unit, :string
  end
end
