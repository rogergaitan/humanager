# == Schema Information
#
# Table name: payment_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PaymentType < ActiveRecord::Base
  
  #has_many :purchase_payment_options

  ##ATTRIBUTES
  attr_accessible :name

  ##VALIDATIONS
  validates :name, 
  	:presence => true, 
  	:uniqueness => { :case_sensitive => false }

end
