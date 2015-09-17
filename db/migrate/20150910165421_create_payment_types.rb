class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.string :description
      t.decimal :factor, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end
