class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :iactivity
      t.string :itask
      t.string :ntask
      t.string :iaccount
      t.decimal :mlaborcost, :precision => 10, :scale => 2
      t.string :nunidad
      t.timestamps
    end
  end
end
