class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :symbol
      t.column :currency_type, :enum, limit:  [:local, :foreign]
      
      t.timestamps
    end
  end
end
