class Currency < ActiveRecord::Base
  attr_accessible :name, :symbol
  
  validate :name, :symbol, :currency_type, presence: true
end
