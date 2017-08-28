class CreateIrTables < ActiveRecord::Migration
  def change
    create_table :ir_tables do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
    end
  end
end
