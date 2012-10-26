# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Occupation < ActiveRecord::Base
	has_many :employees
  	attr_accessible :description
end
