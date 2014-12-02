class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name
      t.string :surname
      t.string :entityid
      t.column :typeid, :enum, :limit => [:national_id, :residence_id, :business_id, :passport, :other]

      t.timestamps
    end
  end
end
