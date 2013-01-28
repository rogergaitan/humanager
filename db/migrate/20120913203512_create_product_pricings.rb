class CreateProductPricings < ActiveRecord::Migration
  def change
    create_table :product_pricings, :force => true do |t|
      t.integer :product_id
      t.float :utility
      t.column :type, :enum, :limit =>[:other, :credit, :cash]
      t.column :category, :enum, :limit =>[:a, :b, :c] 
      t.float :sell_price

      t.timestamps
    end
  end
end
