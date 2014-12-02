class CreateCostsCenters < ActiveRecord::Migration
  def change
    create_table :costs_centers do |t|
      t.string :icompany
      t.string :icost_center
      t.string :name_cc
      t.string :icc_father

      t.timestamps
    end
  end
end
