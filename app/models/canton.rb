# == Schema Information
#
# Table name: cantons
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  province_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Canton < ActiveRecord::Base
  belongs_to :province
  has_many :districts
  attr_accessible :name
end
