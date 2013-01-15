class Company < ActiveRecord::Base
  attr_accessible :address, :company_id, :default, :email, :logo, :name, :surname, :telephone, :web_site

  ## VALIDATIONS
  validates :name, :company_id, :telephone, :address, :presence => true
end
