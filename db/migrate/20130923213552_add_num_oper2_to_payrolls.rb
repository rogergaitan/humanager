class AddNumOper2ToPayrolls < ActiveRecord::Migration
   def change
  	add_column :payrolls, :num_oper_2, :string
  end
end
