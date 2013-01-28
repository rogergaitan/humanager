class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :surname
      t.string :company_id
      t.string :telephone
      t.string :address
      t.string :email
      t.string :web_site
      t.boolean :default
      t.string :logo

      t.timestamps
    end
  end
end
