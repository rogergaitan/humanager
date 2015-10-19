class CreateModelNames < ActiveRecord::Migration
  def change
    create_table :model_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
