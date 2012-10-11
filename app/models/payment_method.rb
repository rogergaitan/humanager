class PaymentMethod < ActiveRecord::Base
  attr_accessible :code, :description
end
