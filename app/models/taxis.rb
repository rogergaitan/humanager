class Taxis < ActiveRecord::Base
  attr_accessible :percentage, :cc_id, :name

  validates :name, :percentage, :cc_id, :presence => true
  validates :percentage, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }
  validates :cc_id, :numericality => { :greater_than => 0 }
end
