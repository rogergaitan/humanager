class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products, :force => true do |t|
      t.string :code
      t.integer :line_id
      t.integer :subline_id
      t.integer :category_id
      t.string :part_number
      t.string :name
      t.string :make
      t.string :model
      t.string :year
      t.string :version
      t.integer :max_discount
      t.string :address
      t.integer :max_cant
      t.integer :min_cant
      t.float :cost
      t.string :bar_code
      t.integer :market_price
      t.column :status, :enum, :limit =>[:active, :inactive, :out_of_stock]
      t.integer :stock
     
      t.timestamps
    end
  end
end
