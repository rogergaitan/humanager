class AddNumOperToPayrolls < ActiveRecord::Migration
  def up
    add_column :payrolls, :num_oper_3, :string
    add_column :payrolls, :num_oper_4, :string
  end

  def down
    remove_column :payrolls, :num_oper_3
    remove_column :payrolls, :num_oper_4
  end
end
