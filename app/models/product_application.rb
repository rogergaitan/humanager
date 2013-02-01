# == Schema Information
#
# Table name: product_applications
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductApplication < ActiveRecord::Base
  belongs_to :product

  attr_accessible :name, :product_id, :id

  validates :product_id, :name, :presence => true
  validates :name, :uniqueness => true
end
