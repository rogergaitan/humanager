class CreateCostCenters < ActiveRecord::Migration
  def change
    create_table :cost_centers do |t|
      t.string :code
      t.string :description
      t.integer :responsible

      t.timestamps
    end
  end
end
