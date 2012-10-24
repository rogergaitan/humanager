# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  email_type :string(255)
#  email      :string(255)
#  entity_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Email < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :email, :email_type
end
