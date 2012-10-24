class Email < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :email, :typeemail
end
