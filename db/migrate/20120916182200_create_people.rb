# -*- encoding : utf-8 -*-
class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :id_person
      t.string :name
      t.string :first_surname
      t.string :second_surname
      t.date :birthday
      t.column :tipoid, :enum, :limit => [:national, :foreign]
      t.column :gender, :enum, :limit => [:male, :female]
      t.column :marital_status, :enum, :limit => [:single, :married, :divorced, :widowed, :civil_union, :engage]

      t.timestamps
    end
  end
end
