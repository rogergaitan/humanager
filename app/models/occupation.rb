# == Schema Information
#
# Table name: occupations
#
#  id           :integer not null, primary key
#  description  :string(255)
#  created_at   :datetime  not null
#  updated_at   :datetime  not null
#

class Occupation < ActiveRecord::Base
	has_many :employees
  attr_accessible :name, :inss_code, :other_code
  
  # Validations
  validates :name, :format => { :with => /^[A-Za-z0-9- ]+$/i }
  validates :name, presence: true, length: { maximum: 30 }
  validates_uniqueness_of :name, case_sensitive: false
  
  validates :inss_code, :other_code, length: { maximum: 20 }
  
  def self.search(name)
    where("name LIKE ?", "#{name}%") 
  end
end
