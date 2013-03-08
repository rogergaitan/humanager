# == Schema Information
#
# Table name: discount_profile_items
#
#  id                  :integer          not null, primary key
#  discount_profile_id :integer
#  item_type           :enum([:product,
#  item_id             :integer
#  discount            :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class DiscountProfileItem < ActiveRecord::Base

  belongs_to :discount_profile

  attr_accessor :name
  attr_accessible :discount, :discount_profile_id, :item_id, :item_type, :name

  validates :discount, :item_id, :item_type, :name, :presence => true
  validates :discount, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }

end
