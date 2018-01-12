class AddProvisioningToWorkBenefitsPayment < ActiveRecord::Migration
  def change
    add_column :work_benefits_payments, :provisioning, :boolean
  end
end
