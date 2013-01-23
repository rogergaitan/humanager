# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  company_id :string(255)
#  telephone  :string(255)
#  address    :string(255)
#  email      :string(255)
#  web_site   :string(255)
#  default    :boolean
#  logo       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  attr_accessible :address, :company_id, :default, :email, :logo, :name, :surname, :telephone, :web_site

  ## VALIDATIONS
  validates :name, :company_id, :telephone, :address, :presence => true
end
