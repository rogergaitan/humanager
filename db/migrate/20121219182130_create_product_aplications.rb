class CreateProductAplications < ActiveRecord::Migration
  def change
    create_table :product_aplications do |t|
      t.string :name
      t.references :product

      t.timestamps
    end
    add_index :product_aplications, :product_id
  end
end
