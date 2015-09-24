class PaymentType < ActiveRecord::Base
  attr_accessible :description, :factor, :name, :contract_code, :payment_type, :state
end
