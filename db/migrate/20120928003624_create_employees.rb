class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :person
      t.string :social_insurance
      t.integer :number_of_dependents
      t.string :spouse
      t.date :join_date
      t.references :department
      t.references :occupation
      t.references :role
      t.references :payment_method
      t.references :payment_frequency
      t.references :means_of_payment
      t.decimal :wage_payment, :precision => 12, :scale => 2
      t.boolean :ccss_calculated

      t.timestamps
    end
    add_index :employees, :person_id
    add_index :employees, :department_id
    add_index :employees, :occupation_id
    add_index :employees, :role_id
    add_index :employees, :payment_method_id
    add_index :employees, :payment_frequency_id
    add_index :employees, :means_of_payment_id
  end
end
