class CreateDiscountProfiles < ActiveRecord::Migration
  def change
    create_table :discount_profiles do |t|
      t.string :description
      t.column :category, :enum, :limit => [:a, :b, :c]
      
      t.timestamps
    end
  end
end
