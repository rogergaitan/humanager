class PaymentType < ActiveRecord::Base
  attr_accessible :description, :factor, :name, :contract_code, :payment_type, :state

  scope :all_payment_types, where('state = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'])

end
