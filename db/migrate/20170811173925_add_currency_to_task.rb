class AddCurrencyToTask < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.references :currency, index: true  
    end
  end
end
