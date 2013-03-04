class RemoveCodigoInsCcssToPositions < ActiveRecord::Migration
  def up
  	remove_column :positions, :codigo_ins
  	remove_column :positions, :codigo_ccss
  	add_column :occupations, :ins_code, :string
  	add_column :occupations, :ccss_code, :string
  end

  def down
  	add_column :positions, :codigo_ins, :string
  	add_column :positions, :codigo_ccss, :string
  	remove_column :occupations, :ins_code
  	remove_column :occupations, :ccss_code
  end
end