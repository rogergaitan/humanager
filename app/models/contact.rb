# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  occupation :string(255)
#  phone      :string(255)
#  email      :string(255)
#  skype      :string(255)
#  entity_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :email, :name, :occupation, :phone, :skype
end
