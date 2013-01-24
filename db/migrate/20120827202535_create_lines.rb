class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :code
      t.string :name
      t.string :description
      t.integer :inventory
      t.integer :sale_cost
      t.integer :utility_adjusment
      t.integer :lost_adjustment
      t.integer :income
      t.integer :sales_return
      t.integer :purchase_return
      t.integer :sale_tax
      t.integer :purchase_tax

      t.timestamps
    end
  end
end
