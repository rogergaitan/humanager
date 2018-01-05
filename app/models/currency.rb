class Currency < ActiveRecord::Base
  attr_accessible :name, :symbol
  
  # Validations
  validates :name, :format => { :with => /^[A-Za-z0-9- ]+$/i }
  validates :name, :symbol, :currency_type, presence: true

  # Constants
  TYPE_LOCAL = :local.freeze
  TYPE_FOREING = :foreing.freeze
end
