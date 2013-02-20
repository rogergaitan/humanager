class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.string :document_number
      t.references :customer
      t.string :currency
      t.date :document_date
      t.date :valid_to
      t.string :payment_term
      t.float :sub_total_free
      t.float :sub_total_taxed
      t.float :tax_total
      t.float :discount_total
      t.float :total
      t.text :notes

      t.timestamps
    end
    add_index :quotations, :customer_id
  end
end
