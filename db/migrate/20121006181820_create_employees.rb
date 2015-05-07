class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :entity
      t.column :gender, :enum, :limit => [:male, :female]
      t.date :birthday
      t.column :marital_status, :enum, :limit => [:single, :married, :divorced, 
                :widowed, :civil_union, :engage]
      t.integer :number_of_dependents
      t.string :spouse
      t.date :join_date
      t.string :social_insurance
      t.references :department
      t.references :occupation
      t.references :role
      t.references :position
      t.boolean :seller
      t.references :payment_method
      t.references :payment_frequency
      t.references :means_of_payment
      t.references :employee
      t.references :payment_unit
      t.references :payroll_type
      t.boolean :is_superior, :default => 0
      t.boolean :price_defined_work
      t.integer :number_employee
      t.string :account_bncr, :limit => 12

      t.decimal :wage_payment, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :employees, :entity_id
    add_index :employees, :department_id
    add_index :employees, :occupation_id
    add_index :employees, :role_id
    add_index :employees, :payment_method_id
    add_index :employees, :payment_frequency_id
    add_index :employees, :means_of_payment_id
    add_index :employees, :position_id
    add_index :employees, :employee_id
    add_index :employees, :payment_unit_id
    add_index :employees, :payroll_type_id
    add_index :employees, :number_employee, :unique => true
  end
end
