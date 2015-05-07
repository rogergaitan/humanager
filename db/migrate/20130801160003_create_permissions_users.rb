class CreatePermissionsUsers < ActiveRecord::Migration
  def change
  	create_table :permissions_users do |t|
      t.references :permissions_subcategory
      t.references :user
      t.boolean :p_create, :default => 0
      t.boolean :p_view, :default => 0
      t.boolean :p_modify, :default => 0
      t.boolean :p_delete, :default => 0
      t.boolean :p_close, :default => 0
      t.boolean :p_accounts, :default => 0
      t.boolean :p_pdf, :default => 0
      t.boolean :p_exel, :default => 0
      t.timestamps

    end
    add_index :permissions_users, :permissions_subcategory_id
    add_index :permissions_users, :user_id
  end
end
