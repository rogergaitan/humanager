class RenamePaymentTypePerformanceUnit < ActiveRecord::Migration
 def change
   rename_column :payment_types, :performance_unit, :payment_unit  
 end
end
