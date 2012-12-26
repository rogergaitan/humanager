class CreateProductApplications < ActiveRecord::Migration
  def change
    create_table :product_applications do |t|
      t.string :name
      t.references :product

      t.timestamps
    end
    add_index :product_applications, :product_id
  end
end
