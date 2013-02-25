class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :document_number
      t.date :document_date
      t.references :customer
      t.string :currency
      t.string :price_list
      t.string :payment_term
      t.date :due_date
      t.references :quotation
      t.boolean :closed
      t.float :sub_total_free
      t.float :sub_total_taxed
      t.float :discount_total
      t.float :tax_total
      t.float :total

      t.timestamps
    end
    add_index :invoices, :customer_id
    add_index :invoices, :quotation_id
  end
end
