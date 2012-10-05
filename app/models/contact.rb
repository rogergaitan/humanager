class Contact < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :email, :name, :occupation, :phone, :skype
end
