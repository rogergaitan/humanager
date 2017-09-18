# == Schema Information
#
# Table name: payment_frequencies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PaymentFrequency < ActiveRecord::Base
  has_many :employees
  attr_accessible :description, :name
  
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
