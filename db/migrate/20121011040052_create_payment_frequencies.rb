class CreatePaymentFrequencies < ActiveRecord::Migration
  def change
    create_table :payment_frequencies do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
