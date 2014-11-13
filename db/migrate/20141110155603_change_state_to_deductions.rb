class ChangeStateToDeductions < ActiveRecord::Migration
  def change
  	change_column(:deductions, :state, :enum, :limit =>[:completed, :active], :default => :active)
  end

end
