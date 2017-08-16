# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  employee_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  costs_center_id
#

class Department < ActiveRecord::Base

	belongs_to :employee 
	belongs_to :costs_center
	has_many :employees
	attr_accessible :name, :employee_id, :costs_center_id

	validates :name, :presence => true, :length => { maximum: 30 }
  validates_uniqueness_of :name, case_sensitive: false
  
  def self.search(query)
    where("name LIKE ?", "#{query}%")
  end
  
end
