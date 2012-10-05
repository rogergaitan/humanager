class Email < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :email, :email_type
end
