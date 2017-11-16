class Currency < ActiveRecord::Base
  attr_accessible :name, :symbol
  
  validates :name, :symbol, :currency_type, presence: true

  # Constants
  TYPE_LOCAL = :local.freeze
  TYPE_FOREING = :foreing.freeze
end
