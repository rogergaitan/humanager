class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name
      t.string :surname
      t.string :entityid
      t.column :typeid, :enum, :limit => [:national, :foreign, :company]

      t.timestamps
    end
  end
end
