class Currency < ActiveRecord::Base
  attr_accessible :name, :symbol, :currency_type
end
