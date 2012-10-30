class ChangeColumNameProductPricings < ActiveRecord::Migration
  def self.up
    rename_column :product_pricings, :type, :price_type
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
