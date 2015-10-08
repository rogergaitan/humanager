class CreateWorkBenefits < ActiveRecord::Migration
  def change
    create_table :work_benefits do |t|
      t.references :company
      t.references :costs_center
      t.string :description
      t.decimal :percentage, :precision => 10, :scale => 2
      t.integer :debit_account
      t.integer :credit_account
      t.string :beneficiary_id
      t.boolean :is_beneficiary, :default => 1
      t.column :state, :enum, :limit =>[:completed, :active], :default => :active

      t.timestamps
    end
    add_index :work_benefits, :company_id
    add_index :work_benefits, :debit_account
    add_index :work_benefits, :credit_account
    add_index :work_benefits, :costs_center_id
  end
end
