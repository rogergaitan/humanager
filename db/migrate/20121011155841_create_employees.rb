class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :entities
      t.date :join_date
      t.enum :gender, :enum, :limit => [:male, :female]
      t.date :birthday
      t.column :marital_status, :enum, :limit => [:single, :married, :divorced, 
                :widowed, :civil_union, :engage]
      t.string :social_insurance
      t.string :number_of_dependents
      t.string :spouse
      t.integer :deparment_id
      t.integer :ocupation_id
      t.integer :role_id
      t.integer :payment_method_id
      t.integer :payment_frecuency_id
      t.integer :means_of_payment_id
      t.integer :wage_payment, :precision => 12, :scale => 2 
      t.boolean :ccss_calculated

      t.timestamps
    end
    add_index :employees, :entities_id
  end
end
