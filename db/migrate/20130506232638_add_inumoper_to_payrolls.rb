class AddInumoperToPayrolls < ActiveRecord::Migration
  def change
  	add_column :payrolls, :num_oper, :string
  end
end