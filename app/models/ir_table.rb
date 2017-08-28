class IrTable < ActiveRecord::Base
  attr_accessible :end_date, :name, :start_date, :ir_table_values_attributes
  
  has_many :ir_table_values
  
  accepts_nested_attributes_for :ir_table_values
  
  validates :name, :start_date, :end_date, presence: true
  
end
