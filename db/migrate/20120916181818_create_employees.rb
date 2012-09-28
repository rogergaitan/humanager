# -*- encoding : utf-8 -*-
class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :person_id
      t.string :social_insurance
      t.string :number_of_dependents
      t.string :spouse
      t.date :join_date
      t.integer :department_id
      t.integer :occupation_id
      t.integer :role_id
      t.integer :payment_method_id
      t.integer :payment_frequency_id
      t.integer :means_of_payment_id
      t.decimal :wage_payment, :precision => 12, :scale => 2
      t.boolean :ccss_calculated
      t.string :fb_employee

      t.timestamps
    end
  end
end
