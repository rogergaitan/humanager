class CreateCostsCenters < ActiveRecord::Migration
  def change
    create_table :costs_centers do |t|
      t.references :company
      t.string :icost_center
      t.string :name_cc
      t.string :icc_father
      t.string :iactivity

      t.timestamps
    end
    add_index :costs_centers, :company_id
  end
end
