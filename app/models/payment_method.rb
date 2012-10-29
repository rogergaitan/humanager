# == Schema Information
#
# Table name: payment_methods
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PaymentMethod < ActiveRecord::Base
	has_many :employees
  	attr_accessible :description, :name
end
