# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  role          :string(255)
#  description   :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Role < ActiveRecord::Base
  belongs_to :department
  attr_accessible :description, :role, :department_id
end
