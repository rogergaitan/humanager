class CreateDiscountProfileItems < ActiveRecord::Migration
  def change
    create_table :discount_profile_items do |t|
      t.integer :discount_profile_id
      t.column :item_type, :enum, :limit => [:product, :subline]
      t.integer :item_id
      t.float :discount

      t.timestamps
    end
  end
end
