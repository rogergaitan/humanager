class CreateDocumentNumbers < ActiveRecord::Migration
  def change
    create_table :document_numbers do |t|
      t.references :company
      t.string :description
      t.column :document_type, :enum, :limit => [:purchase, :purchase_order]
      t.column :number_type, :enum, :limit => [:auto_increment, :manual]
      t.integer :start_number
      t.string :mask
      t.boolean :terminal_restriction

      t.timestamps
    end
    add_index :document_numbers, :company_id
  end
end
