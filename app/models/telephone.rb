# == Schema Information
#
# Table name: telephones
#
#  id         :integer          not null, primary key
#  entity_id  :integer
#  telephone  :string(255)
#  typephone  :enum([:personal,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Telephone < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :telephone, :typephone
end
