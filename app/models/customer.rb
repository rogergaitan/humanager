class Customer < ActiveRecord::Base
  belongs_to :customer_profile
  belongs_to :entity, :dependent => :destroy
  attr_accessible :asigned_seller, :customer_profile_id, :entity_attributes
  accepts_nested_attributes_for :entity, :allow_destroy => true
end
