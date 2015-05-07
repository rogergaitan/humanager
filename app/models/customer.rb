# == Schema Information
#
# Table name: customers
#
#  id                  :integer          not null, primary key
#  asigned_seller      :string(255)
#  customer_profile_id :integer
#  entity_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Customer < ActiveRecord::Base
  belongs_to :customer_profile
  belongs_to :entity, :dependent => :destroy
  attr_accessible :asigned_seller, :customer_profile_id, :entity_attributes
  accepts_nested_attributes_for :entity, :allow_destroy => true
end
