# == Schema Information
#
# Table name: photos
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  name        :string(255)
#  photo       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Photo < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :name, :photo, :employee_id
  mount_uploader :photo, PhotoUploader
end
