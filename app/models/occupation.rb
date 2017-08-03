# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Occupation < ActiveRecord::Base
	has_many :employees
  attr_accessible :name, :inss_code, :other_code
  
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :inss_code, :other_code, length: { maximum: 20 }
  
  def self.search(name)
    where("name LIKE ?", "#{name}%") 
  end
end
