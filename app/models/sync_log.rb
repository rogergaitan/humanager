class SyncLog < ActiveRecord::Base
	attr_accessible :user_id, :last_sync
	
end