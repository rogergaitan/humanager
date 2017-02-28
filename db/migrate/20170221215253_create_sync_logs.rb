class CreateSyncLogs < ActiveRecord::Migration
  def change
    create_table :sync_logs do |t|
    	t.datetime :last_sync
    	t.references :user

      t.timestamps
    end
    add_index :sync_logs, :user_id
  end
end
