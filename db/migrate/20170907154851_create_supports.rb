class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.integer :itdsop
      t.string :ntdsop
      t.string :smask
    end
  end
end
