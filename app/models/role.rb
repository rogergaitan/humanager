# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  role          :string(255)
#  description   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Role < ActiveRecord::Base
  attr_accessible :description, :role
  validates :role, :presence => true, :uniqueness => true
end
