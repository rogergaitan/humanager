class PaymentType < ActiveRecord::Base
  attr_accessible :description, :factor, :name

  validates :name, :presence => true
  validates :factor, :presence => true
end
