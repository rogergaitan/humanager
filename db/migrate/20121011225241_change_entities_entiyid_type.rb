class ChangeEntitiesEntiyidType < ActiveRecord::Migration
def up
  		
  		change_table :entities do |t|
  			t.change :entityid, :string
		end

  	end
end
