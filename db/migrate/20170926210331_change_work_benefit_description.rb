class ChangeWorkBenefitDescription < ActiveRecord::Migration
  def up
    change_table :work_benefits do |t|
      t.rename :description, :name
    end
  end
    
  def down
    change_table :work_benefits do |t|
      t.rename :name, :description
    end
  end
end
