class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.string :description
      t.decimal :factor, :precision => 10, :scale => 2
      t.string :contract_code
      t.column :payment_type, :enum, :limit => [:ordinary, :extra, :double]
      t.column :state, :enum, :limit =>[:completed, :active], :default => :active

      t.timestamps
    end
  end
end
