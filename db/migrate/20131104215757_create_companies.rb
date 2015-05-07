class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :code
      t.string :name
      t.text :label_reports_1
      t.text :label_reports_2
      t.text :label_reports_3

      t.timestamps
    end
  end
end
