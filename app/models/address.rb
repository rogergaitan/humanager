# == Schema Information
#
# Table name: addresses
#
#  id          :integer          not null, primary key
#  address     :string(255)
#  entity_id   :integer
#  province_id :integer
#  canton_id   :integer
#  district_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Address < ActiveRecord::Base
  belongs_to :province
  belongs_to :canton
  belongs_to :district
  belongs_to :entity
  attr_accessible :address, :province_id, :canton_id, :district_id
end
