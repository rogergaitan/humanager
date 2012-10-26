# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Province < ActiveRecord::Base
  has_many :addresses
  has_many :cantons
  has_many :districts

  attr_accessible :name
end
