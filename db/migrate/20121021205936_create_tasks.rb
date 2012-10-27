class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :iactivity
      t.string :itask
      t.string :ntask
      t.string :iaccount
      t.decimal :mlaborcost, :precision => 18, :scale => 4
      t.timestamps
    end
  end
end
