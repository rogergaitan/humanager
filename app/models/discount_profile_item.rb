class DiscountProfileItem < ActiveRecord::Base

  belongs_to :discount_profile

  attr_accessor :name
  attr_accessible :discount, :discount_profile_id, :item_id, :item_type, :name

  validates :discount, :item_id, :item_type, :presence => true
  validates :discount, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }

end
