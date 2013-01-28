class CreateKardexes < ActiveRecord::Migration
  def change
    create_table :kardexes do |t|
      t.references :company
      t.date :mov_date
      t.integer :mov_id
      t.column :mov_type, :enum, :limit => [:input, :output]
      t.string :doc_type
      t.string :doc_number
      t.references :entity
      t.string :current_user
      t.string :code
      t.string :cost_unit
      t.string :discount
      t.string :tax
      t.string :cost_total
      t.string :price_list
      t.string :quantity

      t.timestamps
    end
    add_index :kardexes, :company_id
    add_index :kardexes, :entity_id
  end
end
