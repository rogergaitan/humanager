# == Schema Information
#
# Table name: entities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  entityid   :string(255)
#  typeid     :enum([:national,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Entity < ActiveRecord::Base
	
  has_one  :employee, :dependent => :destroy
	has_many :telephones, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_one :address, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_one  :customer
  has_one  :vendor
	accepts_nested_attributes_for :telephones, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :contacts, :allow_destroy => true
  accepts_nested_attributes_for :employee, :allow_destroy => true

  attr_accessible :entityid, :name, :surname, :telephones_attributes,
                  :emails_attributes, :address_attributes, :contacts_attributes, :employee_attributes

  validates :name, :surname, :entityid, :presence => true

  # Check if some province, canton or district it's used in any record.
  def self.check_if_exist_addresses(id, type)
    @total = 0
    Entity.all().each do |e|
      case type.to_s
        when "province"
          @total += e.addresses.where("province_id = ?", id).count
        when "canton"
          @total += e.addresses.where("canton_id = ?", id).count
        when "district"
          @total += e.addresses.where("district_id = ?", id).count
      end # End Case
    end # End Each
    @total
  end

end

