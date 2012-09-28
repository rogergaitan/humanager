class Email < ActiveRecord::Base
  belongs_to :person
  attr_accessible :email
end
