# == Schema Information
#
# Table name: vendors
#
#  id           :integer          not null, primary key
#  credit_limit :string(255)
#  entity_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vendor < ActiveRecord::Base
  belongs_to :entity, :dependent => :destroy
  attr_accessible :credit_limit, :entity_attributes
  accepts_nested_attributes_for :entity, :allow_destroy => true
end
