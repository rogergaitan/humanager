class Currency < ActiveRecord::Base
  attr_accessible :name, :symbol
  
  validates :name, :symbol, :currency_type, presence: true
end
