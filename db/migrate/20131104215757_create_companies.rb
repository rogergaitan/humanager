class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :code
      t.string :name
      t.text :label_reports

      t.timestamps
    end
  end
end
