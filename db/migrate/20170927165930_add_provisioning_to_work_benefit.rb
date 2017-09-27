class AddProvisioningToWorkBenefit < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.boolean :provisioning  
    end
  end
  
  def down
    remove_column :work_benefits, :provisioning  
  end
  
end
