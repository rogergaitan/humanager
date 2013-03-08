# == Schema Information
#
# Table name: taxes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  percentage :float
#  cc_id      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Taxis < ActiveRecord::Base
  attr_accessible :percentage, :cc_id, :name

  validates :name, :percentage, :cc_id, :presence => true
  validates :percentage, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }
  validates :cc_id, :numericality => { :greater_than => 0 }
end
