class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :id_person
      t.string :name
      t.string :first_surname
      t.string :second_surname
      t.date :birthdate
      t.string :fb_person
      t.column :typeid, :enum, :limit => [:national, :foreign]
      t.column :gender, :enum, :limit => [:male, :female]
      t.column :marital_status, :enum, :limit => [:single, :married, :divorced, :windowd, :civil_union, :engage]

      t.timestamps
    end
  end
end
