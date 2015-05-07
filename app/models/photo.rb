class Photo < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :name, :photo, :employee_id
  mount_uploader :photo, PhotoUploader
end
