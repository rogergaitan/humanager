class AddInsCcssToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :codigo_ins, :string
    add_column :positions, :codigo_ccss, :string
  end
end
