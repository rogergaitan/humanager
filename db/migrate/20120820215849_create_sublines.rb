class CreateSublines < ActiveRecord::Migration
  def change
    create_table :sublines do |t|
      t.string :code
      t.string :description
      t.string :name

      t.timestamps
    end
  end
end
