# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  entity_id  :integer
#  email      :string(255)
#  typeemail  :enum([:personal,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Email < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :email, :typeemail
end
