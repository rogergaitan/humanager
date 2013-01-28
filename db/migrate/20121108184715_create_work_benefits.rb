class CreateWorkBenefits < ActiveRecord::Migration
  def change
    create_table :work_benefits do |t|
      t.string :description
      t.decimal :percentage, :precision => 12, :scale => 2
      t.integer :debit_account
      t.integer :credit_account

      t.timestamps
    end
    add_index :work_benefits, :debit_account
    add_index :work_benefits, :credit_account
  end
end
