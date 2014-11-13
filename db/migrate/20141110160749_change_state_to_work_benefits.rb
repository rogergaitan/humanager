class ChangeStateToWorkBenefits < ActiveRecord::Migration
  def change
  	change_column(:work_benefits, :state, :enum, :limit =>[:completed, :active], :default => :active)
  end

end
