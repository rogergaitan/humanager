class CreateCreditors < ActiveRecord::Migration
  def change
    create_table :creditors do |t|
      t.string :name
      t.string :creditor_id
    end
  end
end
