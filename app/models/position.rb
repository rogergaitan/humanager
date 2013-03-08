# == Schema Information
#
# Table name: positions
#
#  id          :integer          not null, primary key
#  position    :string(255)
#  description :string(255)
#  codigo_ins  :string(255)
#  codigo_ccss :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Position < ActiveRecord::Base
  attr_accessible :description, :position, :codigo_ins, :codigo_ccss
  has_many :employees
  
  validates :position,  :presence => true,
                        :uniqueness => true
end
