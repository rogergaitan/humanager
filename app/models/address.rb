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
  belongs_to :entity
  attr_accessible :address, :department, :municipality, :country
end
