# == Schema Information
#
# Table name: vendors
#
#  id           :integer          not null, primary key
#  credit_limit :string(255)
#  entity_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vendor < ActiveRecord::Base
  
  #ASSOCIATIONS
  belongs_to :entity, :dependent => :destroy
  has_many :purchase_orders
  
  #ATTRIBUTES
  attr_accessible :credit_limit, :entity_attributes
  accepts_nested_attributes_for :entity, :allow_destroy => true
  
  def self.search(search)
 		joins(:entity).where("name LIKE ? OR surname Like ? ", "%#{search}%", "%#{search}%").select('name,surname, vendors.id') if search
 		#where("name like '%#{vendor}%'") if vendor and vendor.length >= 3
  end

end
